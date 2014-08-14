class Graph < ActiveRecord::Base

  #open cases by lawfirm
  def self.open_cases(user)
    user.lawfirm.cases.where(open: true)
  end

  #closed cases by lawfirm
  def self.closed_cases(user)
    user.lawfirm.cases.where(open: false)
  end

  #practice_group names by lawfirm
  def self.user_practice_groups(user)
    user.lawfirm.practicegroups.order(:id).collect { |n| n.group_name }
  end

  def self.user_practice_group_ids(user)
    user.lawfirm.practicegroups.order(:id).collect { |n| n.id }
  end


  #start year should be five years prior to the most recent collection fee_received
  def self.closeout_years
    all_dates = Closeout.all.order(:date_fee_received).collect { |cl| cl.date_fee_received }
    start_year = all_dates.sort.last.year-4
    [start_year, start_year+1,start_year+2,start_year+3,start_year+4]
  end

  def self.time_to_collection(case_name,speed)
    if case_name.timing.order(:created_at).last
      if speed == 'fast'
        case_name.timing.order(:created_at).last.estimated_conclusion_fast
      elsif speed == 'expected'
        case_name.timing.order(:created_at).last.estimated_conclusion_expected
      elsif speed == 'slow'
        case_name.timing.order(:created_at).last.estimated_conclusion_slow
      end
    end
  end

  def self.collection_expectation(case_name,amount)
    if case_name.fee.order(:created_at).last
      if amount == 'high'
        case_name.fee.order(:created_at).last.high_estimate
      elsif amount == 'medium'
        case_name.fee.order(:created_at).last.medium_estimate
      elsif amount == 'low'
        case_name.fee.order(:created_at).last.low_estimate
      elsif amount == 'cost'
        case_name.fee.order(:created_at).last.cost_estimate
      elsif amount == 'referral'
        case_name.fee.order(:created_at).last.referral
      end
    else
      return 0
    end
  end

  def self.bucket_yearly_revenue(case_name,amount,est_current_date,est_conclusion_date,yr1,yr2,yr3,yr4,yr5)
    if est_current_date.year == est_conclusion_date.year
      yr1 += Graph.collection_expectation(case_name,amount)
    elsif est_current_date.year+1 == est_conclusion_date.year
      yr2 += Graph.collection_expectation(case_name,amount)
    elsif est_current_date.year+2 == est_conclusion_date.year
      yr3 += Graph.collection_expectation(case_name,amount)
    elsif est_current_date.year+3 == est_conclusion_date.year
      yr4 += Graph.collection_expectation(case_name,amount)
    elsif est_current_date.year+4 >= est_conclusion_date.year
      yr5 += Graph.collection_expectation(case_name,amount)
    end
  end

end
