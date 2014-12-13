class Graph < ActiveRecord::Base

  #Open cases by lawfirm
  def self.open_cases(user)
    return user.lawfirm.cases.where(open: true).includes(:fees,:timings)
  end

  #Closed cases by lawfirm
  def self.closed_cases(user)
    return user.lawfirm.cases.where(open: false).includes(:closeouts)
  end

  #Practice_group names by lawfirm
  def self.user_practice_groups(user)
    return user.lawfirm.practicegroups.collect(&:group_name)
  end

  def self.user_practice_group_ids(user)
    return user.lawfirm.practicegroups.collect(&:id)
  end

  #Start year should be five years prior to the most recent collection fee_received
  def self.closeout_years
    [Date.today - 4.years,Date.today - 3.years,
      Date.today - 2.years,Date.today - 1.years,
      Date.today]
  end

  #To be used in html.erb for backward looking year categories on charts
  def self.closeout_year_only
    [Date.today.year - 4,Date.today.year - 3,
      Date.today.year - 2,Date.today.year - 1,
      Date.today.year]
  end

  #Calculating date today..date.today+4.years
  def self.expected_years
    [Date.today, Date.today + 1.years,
    Date.today + 2.years ,Date.today + 3.years,
    Date.today + 4.years]
  end

  #To be used in html.erb for forward looking year categories on charts
  def self.expected_year_only
    [Date.today.year, Date.today.year + 1,
    Date.today.year + 2,Date.today.year + 3,
    Date.today.year + 4]
  end

  def self.subtract_arrays(array1,array2)
    return array1.zip(array2).map { |x,y| x-y }
  end

  def self.add_arrays(array1,array2)
    return array1.zip(array2).map { |x,y| x+y }
  end

  #Return sum(closeout.attributee) by user lawfirm, grouped by year over the last 5 years
  def self.closeout_amount_by_year(user,closeout_amount)
    #Starting with 5 year look back
    year_of_collection = [Date.today - 4.years,Date.today - 3.years,Date.today - 2.years,Date.today - 1.years,Date.today]
    amounts = [0,0,0,0,0]

    #For the length of time being examined, check which Closeout.date_fee_received
    #is within the start and end of the year.  If it is, sum it.  Then repeat for
    #all 5 years.
    amounts.length.times do |i|
      amounts[i] = user.lawfirm.cases.where(open: false).joins(:closeouts).
                                where('date_fee_received >= :start_date AND
                                        date_fee_received <= :end_date',
                                    {start_date: year_of_collection[i].beginning_of_year,
                                     end_date: year_of_collection[i].end_of_year}).
                                sum(closeout_amount)
    end
    return amounts
  end

  def self.total_overhead_per_year(user)
    #Set the last five years dates, and Sum all of the expenses per year to arrive at overhead costs
    years_of_collection = Graph.closeout_year_only
    amounts = Array.new(years_of_collection.length,0)

    #Take the overhead for the lawfirm, and if ovh.year matches the years_of_collection[year]
    #Sum all the amounts fo that year
    user.lawfirm.overheads.each do |ovh|
      amounts.length.times do |i|
        if ovh.year == years_of_collection[i]
          amounts[i] += ovh.rent
          amounts[i] += ovh.utilities
          amounts[i] += ovh.technology
          amounts[i] += ovh.hard_costs
          amounts[i] += ovh.guaranteed_salaries
          amounts[i] += ovh.other
        end
      end
    end
    return amounts
  end

  #Return sum of closed cases, Closeout.closeout_amount by origination.referral_source by year lookback
  def self.closeout_amount_by_origination(user,referral_source,closeout_amount,test_year=3)
    start_date = Date.today.beginning_of_year - (test_year).years
    user.lawfirm.cases.where(open: false).joins(:originations, :closeouts).
          where('referral_source = ?', referral_source).
          where('date_fee_received > ?', start_date).
          sum(closeout_amount)
  end

  #For Pie Charts, do not want values returned to JS template with <= 0
  #because they do not show up in the graph except for the name, taking unnecessary space
  def self.remove_arrays_less_than_or_equal_to(items,amount)
    for remove_me in items
      #Check the second element in the array, because the structure is
      #[["item name","amount"],["item name2","amount2"]
      if remove_me[1] <= amount
        items.delete(remove_me)

        #Recursive because if it finds one items less than, it deletes and ends the call
        #Not functional if there is more than one itemname with amount less<=amonut.
        #Probably a better way to do this.
        remove_arrays_less_than_or_equal_to(items,amount)
      end
    end
    return items
  end

  #Return a list of closed cases from beginning of number of years ago to today
  #For us in graphs_actuals_controller.closed_case_load_by_year
  def self.closed_cases_after(user,test_year=3)
    #Start from Beginning of year, and if test_year is provided, then go back beginning_of_year - test_year
    start_date = Date.today - (test_year).years
    final_case_count = []

    #Loop through practicegroups, and collect count of cases that belong to each practice group
    practice_groups = Graph.user_practice_group_ids(user)
    practice_groups.each do |pg|
      closed_case_count = user.lawfirm.cases.where(open: false).joins(:closeouts).
                        where("date_fee_received > ?", start_date).
                        where('practicegroup_id = ?', pg).count
      final_case_count.push(closed_case_count)
    end
    #Return the [[practicegroupname,case_count],[pg,cc]]..etc
    practice_group_names = user.lawfirm.practicegroups.where(id: practice_groups).collect(&:group_name)
    return practice_group_names.zip(final_case_count)
  end

  #Sums the #{closeout_amount} by practicegroup looking back the number of years selected
  def self.closed_cases_by_pg_and_closeout_type(user,closeout_amount,test_year=3)
    #Get practice group by IDs, and array the length of practice groups to store amounts,
    #and the start_date as a base.
    practice_groups = Graph.user_practice_group_ids(user)
    amounts = Array.new(practice_groups.length)
    start_date = Date.today - (test_year).years
    all_pg_closeout_amounts = []

    #Loop through practice groups with closed cases and inner join closeouts.
    practice_groups.each do |pg|
      pg_closeout_amount = user.lawfirm.cases.where(open: false, practicegroup_id: pg).joins(:closeouts).
                                #If the date_fee_received is after the specified start_date
                                where("date_fee_received > ?", start_date).
                                #Return the specified closeout_amount
                                sum(closeout_amount)
      all_pg_closeout_amounts << pg_closeout_amount
    end
    #Collect all user practicegroup names and combine them with the amounts from above
    practice_group_names = user.lawfirm.practicegroups.where(id: practice_groups).collect(&:group_name)
    return practice_group_names.zip(all_pg_closeout_amounts)
  end

  #Return a Hash of all Practice Groups with revenue by year for past five years
  def self.revenue_by_practice_group_actual(user,closeout_amount)
    #Set variables, past 5 years, amounts earned in those years, and Practicegroups
    year_of_collection = Graph.closeout_years
    final_tally = []
    practice_groups = Graph.user_practice_group_ids(user)

    #Loop through practicegroups, and then loop through amounts,
    #summing the #{closeout amount} for that year.
    #Add [practicegroup_id, [amounts]] to final_tally, and reset amounts to 0 for the next PG.
    practice_groups.each do |pg|
      amounts = Array.new(year_of_collection.length,0)
      amounts.length.times do |i|
        amounts[i] = user.lawfirm.cases.where(open: false, practicegroup_id: pg).joins(:closeouts).
                    where('date_fee_received >= :start_date AND date_fee_received <= :end_date',
                          {start_date: year_of_collection[i].beginning_of_year,
                           end_date: year_of_collection[i].end_of_year}).
                    sum(closeout_amount)
      end
      final_tally << [pg,amounts]
    end

    #Change the practicegroup_ids to the actual practice_group_names
    final_tally.each { |x| x[0] = user.lawfirm.practicegroups.find_by(id: x[0]).group_name }

    #Return a hash for each practicegroup that is
      #{name: PG.group_name, data: [amounts]}
    final_tally_to_hash = final_tally.map { |name,values|  { 'name' => name, 'data' => values } }.to_json
    return final_tally_to_hash
  end

  #Return the summed closeout_amount for a user's lawfirm by fee_type
  def self.revenue_by_fee_type_actual(user,fee_type,closeout_amount)
    #Get the previous 4 years and this year, with corresponding amounts by year
    year_of_collection = Graph.closeout_years
    amounts = [0,0,0,0,0]

    amounts.length.times do |i|
      #Join closeouts with cases, match fee_type and match year[i]. Sum closeout amount
      amounts[i] = user.lawfirm.cases.where(open: false).joins(:closeouts).
                    where('fee_type = ?', fee_type).
                    where('date_fee_received >= :start_date AND date_fee_received <= :end_date',
                          {start_date: year_of_collection[i].beginning_of_year,
                           end_date: year_of_collection[i].end_of_year}).
                    sum(closeout_amount)
    end
    return amounts
  end

  #Need to remove Client.methods that handle this. Client.method is unbearably slow
  def self.revenue_by_client(user,client,closeout_amount)

  end

  #Return array of closeout_amounts for past 5 years by client
  def self.client_profitability_actual_by_year(client, closeout_amount)
    year_of_collection = Graph.closeout_years
    amounts = Array.new(year_of_collection.length)
    #Join closeout amounts with client.cases, and sum amounts for the year in question
    amounts.length.times do |i|
        amounts[i] = client.cases.where(open: false).joins(:closeouts).
                          where('date_fee_received >= :start_date AND date_fee_received <= :end_date',
                                {start_date: year_of_collection[i].beginning_of_year,
                                 end_date: year_of_collection[i].end_of_year}).
                          sum(closeout_amount)
    end
    return amounts
  end

  def all_closeout_attributes
    ["total_recovery",
    "total_gross_fee_received",
    "total_out_of_pocket_expenses",
    "referring_fees_paid",
    "total_fee_received"]
  end

#----------------Individual Practice Groups --- Actual ---------------------------

  #Calculate closeoutamounts by specified practicegroup
  def self.closeout_by_year_pg(user,pg,closeout_amount)
    #Set variables, collect amounts based of length of years
    year_of_collection = Graph.closeout_years
    amounts = Array.new(year_of_collection.length)

    #Loop through closed cases with practicegroup_id
    #Sum #{closeout_amount} if date_fee_received between start_date and end_date
    amounts.length.times do |i|
      amounts[i] = user.lawfirm.cases.where(practicegroup_id: pg, open: false).joins(:closeouts).
                        where('date_fee_received >= :start_date AND date_fee_received <= :end_date',
                          { start_date: year_of_collection[i].beginning_of_year,
                            end_date: year_of_collection[i].end_of_year}).
                        sum(closeout_amount)
    end
    return amounts
  end

  def self.all_origination_source_rev_pg(user,pg,closeout_amount)
    #Gather all referral sources and make amounts based off length of sources
    all_referral_sources = Origination.all_referral_sources(user)
    amounts = Array.new(all_referral_sources.length)

    #Loop through amounts, call method to sum #{closeout_amount}
    amounts.length.times do |i|
      amounts[i] = Graph.revenue_by_origination_pg(user,pg,all_referral_sources[i],closeout_amount)
    end
    return all_referral_sources.zip(amounts)
  end

  def self.revenue_by_origination_pg(user,pg,referral_source,closeout_amount)
    #Sum #{closeout_amount} by practicegroup and referral_source
    return user.lawfirm.cases.where(open: false, practicegroup_id: pg).joins(:originations, :closeouts).
          where('referral_source = ?', referral_source).sum(closeout_amount)
  end

  def self.rev_by_fee_type_pg(user,pg,closeout_amount)
    #Gather all fee_types and years
    year_of_collection = Graph.closeout_years
    all_fee_types = Fee.all.collect(&:fee_type).uniq
    final = []

    #Loop through all fee_types, create amounts_array that is length of years
    #Loop amount.length(years); case (closed, practicegroup) and date_fee_received between start
    #and end_dates, sum #{closeout_amounts}
    all_fee_types.each do |type|
      amounts = Array.new(year_of_collection.length, 0)
      amounts.length.times do |i|
        amounts[i] = user.lawfirm.cases.where(open: false, practicegroup_id: pg).joins(:closeouts).
                          where('fee_type = ?', type).
                          where('date_fee_received >= :start_date AND date_fee_received <= :end_date',
                            { start_date: year_of_collection[i].beginning_of_year,
                              end_date: year_of_collection[i].end_of_year }).
                          sum(closeout_amount)
      end
      final << amounts
    end
    return all_fee_types.zip(final).map { |name,values|  { 'name' => name, 'data' => values } }.to_json
  end

  #------------------------------------STARTING EXPECTED-------------------------------#
  def self.expected_overhead_next_year(user)
    amount = 0
    ovh = user.lawfirm.overheads.where(year: Date.today.year).last
    amount += ovh.rent
    amount += ovh.utilities
    amount += ovh.technology
    amount += ovh.hard_costs
    amount += ovh.guaranteed_salaries
    amount += ovh.other
    return amount
  end

  def self.overhead_by_month(user)
    return Graph.expected_overhead_next_year(user) / 12
  end

  def self.open_cases_by_pg(user)
    final_case_count = []
    #Loop through practicegroups, and collect count of OPEN==true cases that belong to each practice group
    practice_groups = Graph.user_practice_group_ids(user)
    practice_groups.each do |pg|
      open_case_count = user.lawfirm.cases.where(open: true).
                        where('practicegroup_id = ?', pg).count
      final_case_count.push(open_case_count)
    end
    #Return the [[practicegroupname,case_count],[pg,cc]]..etc
    practice_group_names = user.lawfirm.practicegroups.where(id: practice_groups).collect(&:group_name)
    return practice_group_names.zip(final_case_count)
  end

  #Sums the #{fee_estimate} by practicegroup
  def self.open_cases_by_pg_and_fee_estimate(user,fee_estimate)
    #Get practice group by IDs, and array the length of practice groups to store amounts,
    #and the start_date as a base.
    practice_groups_ids = Graph.user_practice_group_ids(user)
    amounts = Array.new(practice_groups_ids.length)
    all_pg_fees = []

    #Loop through practice groups with open cases and inner join closeouts.
    practice_groups_ids.each do |pg|
      pg_fee_estimate = user.lawfirm.cases.where(open: false, practicegroup_id: pg).joins(:fees).
                                #Return the specified fee_estimate
                                sum(fee_estimate)
      all_pg_fees << pg_fee_estimate
    end
    #Collect all user practicegroup names and combine them with the amounts from above
    practice_group_names = user.lawfirm.practicegroups.where(id: practice_groups_ids).collect(&:group_name)
    return practice_group_names.zip(all_pg_fees)
  end

  #Estimated revenue by practicegroup by fee_type next 5 years
  def self.revenue_by_practice_group_estimated(user,fee_estimate,timing_estimate)
    #Set variables, next 5 years (including current year),
    #fee_estimates in those years, and Practicegroups
    year_of_collection = Graph.expected_years
    final_tally = []
    practice_groups_ids = Graph.user_practice_group_ids(user)

    #Loop through practicegroups, and then loop through amounts,
    #summing the #{closeout amount} for that year.
    #Add [practicegroup_id, [amounts]] to final_tally, and reset amounts to 0 for the next PG.
    practice_groups_ids.each do |pg|
      amounts = Array.new(year_of_collection.length,0)
      amounts.length.times do |i|
        amounts[i] = user.lawfirm.cases.where(open: true, practicegroup_id: pg).joins(:timings, :fees).
                    where("#{timing_estimate} >= :start_date AND #{timing_estimate} <= :end_date",
                          {start_date: year_of_collection[i].beginning_of_year,
                           end_date: year_of_collection[i].end_of_year}).
                    sum(fee_estimate)
      end
      final_tally << [pg,amounts]
    end

    #Change the practicegroup_ids to the actual practice_group_names
    final_tally.each { |x| x[0] = user.lawfirm.practicegroups.find_by(id: x[0]).group_name }

    #Return a hash for each practicegroup that is
      #{name: PG.group_name, data: [amounts]}
    final_tally_to_hash = final_tally.map { |name,values|  { 'name' => name, 'data' => values } }.to_json
    return final_tally_to_hash
  end


end
