class GraphDrilldownsController < ApplicationController
  before_action :signed_in_user, :belongs_to_firm, :has_open_cases, :has_overhead_last_year

  def set_category_months
    @category_months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sept','Oct','Nov','Dec']
  end

  def rev_by_year
    @recovery_rate = params[:recovery_rate] || 'expected'
    @year = params[:year] || ''
    @category_years = Graph.expected_year_only

    rev_by_year_high = Graph.fee_estimate_by_year(current_user,"estimated_conclusion_#{@recovery_rate}","high_estimate")
    rev_by_year_medium = Graph.fee_estimate_by_year(current_user,"estimated_conclusion_#{@recovery_rate}","medium_estimate")
    rev_by_year_low = Graph.fee_estimate_by_year(current_user,"estimated_conclusion_#{@recovery_rate}","low_estimate")
    @cost_by_year = Graph.fee_estimate_by_year(current_user,"estimated_conclusion_#{@recovery_rate}","cost_estimate").map { |x| x*-1}
    @referral_by_year = Graph.fee_estimate_by_year(current_user,"estimated_conclusion_#{@recovery_rate}","referral").map { |x| x*-1}
    @category_years = Graph.expected_year_only
    @rev_by_year_high = Graph.add_arrays(rev_by_year_high, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @rev_by_year_medium = Graph.add_arrays(rev_by_year_medium, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @rev_by_year_low = Graph.add_arrays(rev_by_year_low, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @overhead_by_year = Array.new(@rev_by_year_low.length, Graph.expected_overhead_next_year(current_user)).map { |x| x*-1 }
  end

  def rev_year
    @recovery_rate = params[:recovery_rate]
    @year = params[:year].to_i
    @category_years = Graph.expected_year_only
    set_category_months
    @year_by_month_low = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_#{@recovery_rate}","low_estimate", @year)
    @year_by_month_medium = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_#{@recovery_rate}","medium_estimate", @year)
    @year_by_month_high = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_#{@recovery_rate}","high_estimate", @year)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

end
