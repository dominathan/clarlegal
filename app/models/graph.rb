class Graph < ActiveRecord::Base

  #open cases by lawfirm
  def self.open_cases(user)
    user.lawfirm.cases.where(open: true).includes(:fees,:timings)
  end

  #closed cases by lawfirm
  def self.closed_cases(user)
    user.lawfirm.cases.where(open: false).includes(:closeouts)
  end

  #practice_group names by lawfirm
  def self.user_practice_groups(user)
    user.lawfirm.practicegroups.collect(&:group_name)
  end

  def self.user_practice_group_ids(user)
    user.lawfirm.practicegroups.collect(&:id)
  end

  #start year should be five years prior to the most recent collection fee_received
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

  #To be used in html.erb for forward looking year categories on charts
  def self.expected_year_only
    [Date.today.year, Date.today.year + 1,
    Date.today.year + 2,Date.today.year + 3,
    Date.today.year + 4]
  end

  def self.time_to_collection(case_name,speed)
    if case_name.timing.order(:created_at).last
      if speed == 'fast'
        case_name.timing.order(:created_at).last.estimated_conclusion_fast ? case_name.timing.order(:created_at).last.estimated_conclusion_fast : 0
      elsif speed == 'expected'
        case_name.timing.order(:created_at).last.estimated_conclusion_expected ? case_name.timing.order(:created_at).last.estimated_conclusion_expected : 0
      elsif speed == 'slow'
        case_name.timing.order(:created_at).last.estimated_conclusion_slow ? case_name.timing.order(:created_at).last.estimated_conclusion_slow : 0
      end
    end
  end

  def self.collection_expectation(case_name,amount)
    if case_name.fee.order(:created_at).last
      if amount == 'high'
        case_name.fee.order(:created_at).last.high_estimate ? case_name.fee.order(:created_at).last.high_estimate : 0
      elsif amount == 'medium'
        case_name.fee.order(:created_at).last.medium_estimate ? case_name.fee.order(:created_at).last.medium_estimate : 0
      elsif amount == 'low'
        case_name.fee.order(:created_at).last.low_estimate ? case_name.fee.order(:created_at).last.low_estimate : 0
      elsif amount == 'cost'
        case_name.fee.order(:created_at).last.cost_estimate ?  case_name.fee.order(:created_at).last.cost_estimate : 0
      elsif amount == 'referral'
        case_name.fee.order(:created_at).last.referral ? case_name.fee.order(:created_at).last.referral : 0
      end
    else
      return 0
    end
  end

  def self.subtract_arrays(array1,array2)
    subtracted_array = array1.zip(array2).map { |x,y| x-y }
    subtracted_array
  end

  def self.add_arrays(array1,array2)
    added_array = array1.zip(array2).map { |x,y| x+y }
    added_array
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
      amounts[i] = user.lawfirm.cases.where(open: false).joins(:closeouts).where(
        'date_fee_received >= :start_date AND date_fee_received <= :end_date',
        {start_date: year_of_collection[i].beginning_of_year,
         end_date: year_of_collection[i].end_of_year}).sum(closeout_amount)
    end
    return amounts
  end

  def self.total_overhead_per_year(user)
    #Set the last five years dates, and Sum all of the expenses per year to arrive at overhead costs
    years_of_collection = Graph.closeout_year_only
    amounts = [0,0,0,0,0]

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

  #Return sum of closed cases, Closeout.closeout_amount by origination.referral_source
  def self.closeout_amount_by_origination(user,referral_source,closeout_amount)
    user.lawfirm.cases.where(open: false).joins(:originations, :closeouts).where(
      'referral_source = ?', referral_source).sum(closeout_amount)
  end

  #For Pie Charts, do not want values returned to JS template with <= 0
  #because they do not show up in the graph except for the name, taking unnecessary space
  def self.remove_arrays_less_than_or_equal_to(items,amount)
    for remove_me in items
      #Check the second element in the array, because the structure is
      #[["item name","amount"],["item name2","amount2"]
      if remove_me[1] <= amount
        items.delete!(remove_me)

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
    start_date = Date.today.beginning_of_year - (test_year).years
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


  def self.closed_cases_by_pg_and_closeout_type(user,closeout_amount,test_year=3)
    practice_groups = Graph.user_practice_group_ids(user)
    amounts = Array.new(practice_groups.length)
    start_date = Date.today.beginning_of_year - (test_year).years
    all_pg_closeout_amounts = []

    practice_groups.each do |pg|
      pg_closeout_amount = user.lawfirm.cases.where(open: false, practicegroup_id: pg).joins(:closeouts).
                                where("date_fee_received > ?", start_date).
                                sum(closeout_amount)
      all_pg_closeout_amounts << pg_closeout_amount
    end
    practice_group_names = user.lawfirm.practicegroups.where(id: practice_groups).collect(&:group_name)
    practice_group_names.zip(all_pg_closeout_amounts)
  end

  #Return a Hash of all Practice Groups with revenue by year for past five years
  def self.revenue_by_practice_group_actual(user,closeout_amount)
    #Set variables, past 5 years, amounts earned in those years, and Practicegroups
    year_of_collection = Graph.closeout_years
    amounts = [0,0,0,0,0]
    final_tally = []
    practice_groups = Graph.user_practice_group_ids(user)

    #Loop through practicegroups, and then loop through amounts,
    #summing the #{closeout amount} for that year.
    #Add [practicegroup_id, [amounts]] to final_tally, and reset amounts to 0 for the next PG.
    practice_groups.each do |pg|
      amounts.length.times do |i|
        amounts[i] = user.lawfirm.cases.where(open: false, practicegroup_id: pg).joins(:closeouts).
                    where('date_fee_received >= :start_date AND date_fee_received <= :end_date',
                          {start_date: year_of_collection[i].beginning_of_year,
                           end_date: year_of_collection[i].end_of_year}).
                    sum(closeout_amount)
      end
      final_tally << [pg,amounts]
      amounts = [0,0,0,0,0]
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
    amounts
  end

  def self.revenue_by_client(user,client,closeout_amount)
    #need to remove Client.methods that handle this
  end

end
