class GraphsController < ApplicationController
  before_action :signed_in_user
  before_action :belongs_to_firm

  def practice_group_pie
    #filter by practice_group ... pg
    @case_count_by_pg = []
    @lawfirm_pgs = current_user.lawfirm.practicegroups.collect { |n| n.group_name }
    @pg_count = @lawfirm_pgs.length
    0.upto(@pg_count-1) do |n|
      @case_count_by_pg.push(current_user.lawfirm.cases.where(practice_group: @lawfirm_pgs[n]).count)
    end
    @final_data = @lawfirm_pgs.zip(@case_count_by_pg)
  end

  def practice_group_revenue_pie_low
    @lawfirm_pgs = current_user.lawfirm.practicegroups.collect { |n| n.group_name }
    #need to have one for high, one for medium, one for low
    @total_rev_per_pg_low = []
    @lawfirm_pgs.each do |pg|
      sum_total = 0
      current_user.lawfirm.cases.where(practice_group: pg).each do |ca|
        sum_total += ca.fee.last.low_estimate
      end
      @total_rev_per_pg_low << sum_total
    end
    @final_low_rev = @lawfirm_pgs.zip(@total_rev_per_pg_low)
    practice_group_revenue_pie_medium
    practice_group_revenue_pie_high
  end

  def practice_group_revenue_pie_medium
    @lawfirm_pgs = current_user.lawfirm.practicegroups.collect { |n| n.group_name }
    @total_rev_per_pg_medium = []
    @lawfirm_pgs.each do |pg|
      sum_total = 0
      current_user.lawfirm.cases.where(practice_group: pg).each do |ca|
        sum_total += ca.fee.last.medium_estimate
      end
      @total_rev_per_pg_medium << sum_total
    end
    @final_medium_rev = @lawfirm_pgs.zip(@total_rev_per_pg_medium)
  end

  def practice_group_revenue_pie_high
    @lawfirm_pgs = current_user.lawfirm.practicegroups.collect { |n| n.group_name }
    @total_rev_per_pg_high = []
    @lawfirm_pgs.each do |pg|
      sum_total = 0
      current_user.lawfirm.cases.where(practice_group: pg).each do |ca|
        sum_total += ca.fee.last.high_estimate
      end
      @total_rev_per_pg_high << sum_total
    end
    @final_high_rev = @lawfirm_pgs.zip(@total_rev_per_pg_high)
  end

  def case_revenue_by_year
    #graph for HIGH REVENUE ESTIMATE on MEDIUM EXPECTED COLLECTION DATES
    #this is for expected conclusion date and high revenues
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    rev_est_year1 = 0
    rev_est_year2 = 0
    rev_est_year3 = 0
    rev_est_year4 = 0
    rev_est_year5_plus = 0
    @high_final_estimate = []
    current_user.lawfirm.cases.each do |ca|
      conclusion_date = current_date.to_time.advance(:months => (ca.timing.last.estimated_conclusion_expected))
      if current_date.year == conclusion_date.year
        rev_est_year1 += ca.fee.last.high_estimate
      elsif current_date.year+1 == conclusion_date.year
        rev_est_year2 += ca.fee.last.high_estimate
      elsif current_date.year+2 == conclusion_date.year
        rev_est_year3 += ca.fee.last.high_estimate
      elsif current_date.year+3 == conclusion_date.year
        rev_est_year4 += ca.fee.last.high_estimate
      elsif current_date.year+4 >= conclusion_date.year
        rev_est_year5_plus += ca.fee.last.high_estimate
      end
    end
    case_revenue_by_year_low
    case_revenue_by_year_medium
    @high_final_estimate.push(rev_est_year1,rev_est_year2,rev_est_year3,rev_est_year4,rev_est_year5_plus)
    #@final_json = { "name"=> 'High Rev Est.', "data"=>final_estimate }.to_json

  end

  def case_revenue_by_year_medium
    current_date = DateTime.now
    rev_est_year1 = 0
    rev_est_year2 = 0
    rev_est_year3 = 0
    rev_est_year4 = 0
    rev_est_year5_plus = 0
    @medium_final_estimate = []
    current_user.lawfirm.cases.each do |ca|
      conclusion_date = current_date.to_time.advance(:months => (ca.timing.last.estimated_conclusion_expected))
      if current_date.year == conclusion_date.year
        rev_est_year1 += ca.fee.last.medium_estimate
      elsif current_date.year+1 == conclusion_date.year
        rev_est_year2 += ca.fee.last.medium_estimate
      elsif current_date.year+2 == conclusion_date.year
        rev_est_year3 += ca.fee.last.medium_estimate
      elsif current_date.year+3 == conclusion_date.year
        rev_est_year4 += ca.fee.last.medium_estimate
      elsif current_date.year+4 >= conclusion_date.year
        rev_est_year5_plus += ca.fee.last.medium_estimate
      end
    end
    @medium_final_estimate.push(rev_est_year1,rev_est_year2,rev_est_year3,rev_est_year4,rev_est_year5_plus)
    #@med_final_json = { "name"=> 'Medium Rev Est.', "data"=>final_estimate }.to_json
  end

    def case_revenue_by_year_low
    current_date = DateTime.now
    rev_est_year1 = 0
    rev_est_year2 = 0
    rev_est_year3 = 0
    rev_est_year4 = 0
    rev_est_year5_plus = 0
    @low_final_estimate = []
    current_user.lawfirm.cases.each do |ca|
      conclusion_date = current_date.to_time.advance(:months => (ca.timing.last.estimated_conclusion_expected))
      if current_date.year == conclusion_date.year
        rev_est_year1 += ca.fee.last.low_estimate
      elsif current_date.year+1 == conclusion_date.year
        rev_est_year2 += ca.fee.last.low_estimate
      elsif current_date.year+2 == conclusion_date.year
        rev_est_year3 += ca.fee.last.low_estimate
      elsif current_date.year+3 == conclusion_date.year
        rev_est_year4 += ca.fee.last.low_estimate
      elsif current_date.year+4 >= conclusion_date.year
        rev_est_year5_plus += ca.fee.last.low_estimate
      end
    end
    @low_final_estimate.push(rev_est_year1,rev_est_year2,rev_est_year3,rev_est_year4,rev_est_year5_plus)
    #@med_final_json = { "name"=> 'Medium Rev Est.', "data"=>final_estimate }.to_json
  end



end
