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
    [Date.today.year - 4,Date.today.year - 3,Date.today.year - 2,Date.today.year - 1,Date.today.year]
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

  def self.find_outliers(case_listing)
    outliers = []
    case_listing.each do |ca|
      if ca.fee.last.high_estimate < ca.fee.last.medium_estimate ||
         ca.fee.last.medium_estimate < ca.fee.last.low_estimate
            outliers << ca
      end
    end
    outliers
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
  def self.closed_cases_after(user,test_year=3)
    #Start from Beginning of year, and if test_year is provided, then go back beginning_of_year - test_year
    start_date = Date.today.beginning_of_year - test_year.years
    final_case_count = []

    #Loop through practicegroups, and collect count of cases that belong to each practice group
    practice_groups = Graph.user_practice_groups(user)
    practice_groups.each do |pg|
      closed_case_count = user.lawfirm.cases.where(open: false).joins(:closeouts).
                        where("date_fee_received > ?", start_date).
                        where('practice_group = ?', pg).count
      final_case_count.push(closed_case_count)
    end
    #Return the [[practicegroupname,case_count],[pg,cc]]..etc
    return practice_groups.zip(final_case_count)
  end

end
