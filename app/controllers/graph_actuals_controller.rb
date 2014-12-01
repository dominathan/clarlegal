class GraphActualsController < ApplicationController

  #Using params[:range], sets number of years to collect closed cases
  def closed_case_load_by_year
    #If params[:range] not set, default => 3 year lookback
    if params[:range] == nil
      @final_closed_cases_by_pg = Graph.remove_arrays_less_than_or_equal_to(Graph.closed_cases_after(current_user),0)
    else
      @final_closed_cases_by_pg = Graph.remove_arrays_less_than_or_equal_to(Graph.closed_cases_after(current_user, params[:range].to_i),0)
    end
  end

  def revenue_by_year
  #Get all Closeout values belonging to User Lawfirm.  Expenses are made negative.
  #See Graph.closeamount_by_year(user,closeout.attribute) for more information.
    #Using all 5 dollar amounts in Closeout Model for graph.
    @total_recovery = Graph.closeout_amount_by_year(current_user,"total_recovery")
    @total_gross_fee_received = Graph.closeout_amount_by_year(current_user,"total_gross_fee_received")
    @total_out_of_pocket_expenses =  Graph.closeout_amount_by_year(current_user,"total_out_of_pocket_expenses").map { |i| i *- 1}
    @referring_fees_paid = Graph.closeout_amount_by_year(current_user,"referring_fees_paid").map {|i| i * -1}
    @total_fee_received = Graph.closeout_amount_by_year(current_user,"total_fee_received")
    #Consider adding Hours Worked * Overhead as a cost as well to get Profit
  end

  def revenue_by_pg
    @pgs_total_fee_received = Graph.revenue_by_practice_group(current_user,'total_fee_received')
  end

  def revenue_by_fee_type
  end

  def revenue_by_origination
  end

  def revenue_by_client
  end
end
