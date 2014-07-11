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




end
