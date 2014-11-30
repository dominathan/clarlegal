class GraphActualsController < ApplicationController

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
  end

  def revenue_by_fee_type
  end

  def revenue_by_origination
  end

  def revenue_by_client
  end
end
