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
    user.lawfirm.practicegroups.collect { |n| n.group_name }
  end

  #start year should be five years prior to the most recent collection fee_received
  def self.closeout_years
    all_dates = Closeout.all.order(:date_fee_received).collect { |cl| cl.date_fee_received }
    start_year = all_dates.sort.last.year-4
    [start_year, start_year+1,start_year+2,start_year+3,start_year+4]
  end







  def revenue_collection_by_year(collection_rate,collection_amount)
    set_yearly_rev
    current_user.lawfirm.cases.each do |ca|
      conclusion_date = @current_date.to_time.advance(:months => (time_to_collection(ca,collection_rate)))
      if @current_date.year == conclusion_date.year
        @rev_est_year1 += collection_expectation(ca,collection_amount)
      elsif @current_date.year+1 == conclusion_date.year
        @rev_est_year2 += collection_expectation(ca,collection_amount)
      elsif @current_date.year+2 == conclusion_date.year
        @rev_est_year3 += collection_expectation(ca,collection_amount)
      elsif @current_date.year+3 == conclusion_date.year
        @rev_est_year4 += collection_expectation(ca,collection_amount)
      elsif @current_date.year+4 >= conclusion_date.year
        @rev_est_year5_plus += collection_expectation(ca,collection_amount)
      end
    end
  end

  def cost_by_year(collection_rate,collection_amount)
    #change the -= to += for above the line grid, also works for line graph if positive
    set_yearly_rev
    current_user.lawfirm.cases.each do |ca|
      conclusion_date = @current_date.to_time.advance(:months => (time_to_collection(ca,collection_rate)))
      if ca.fee.last
        if ca.fee.last.cost_estimate != nil
          if @current_date.year == conclusion_date.year
            @rev_est_year1 -= collection_expectation(ca,collection_amount)
          elsif @current_date.year+1 == conclusion_date.year
            @rev_est_year2 -= collection_expectation(ca,collection_amount)
          elsif @current_date.year+2 == conclusion_date.year
            @rev_est_year3 -= collection_expectation(ca,collection_amount)
          elsif @current_date.year+3 == conclusion_date.year
            @rev_est_year4 -= collection_expectation(ca,collection_amount)
          elsif @current_date.year+4 >= conclusion_date.year
            @rev_est_year5_plus -= collection_expectation(ca,collection_amount)
          end
        else
          next
        end
      end
    end
  end



end
