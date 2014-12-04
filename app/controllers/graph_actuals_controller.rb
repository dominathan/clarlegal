class GraphActualsController < ApplicationController
  before_action :signed_in_user, :belongs_to_firm, :has_closed_cases
  before_action :has_overhead_last_5_years
  #Using params[:range], sets number of years to collect closed cases
  def closed_case_load_by_year
    #If params[:range] not set, default => 3 year lookback
    if params[:range] == nil
      @final_closed_cases_by_pg = Graph.remove_arrays_less_than_or_equal_to(Graph.closed_cases_after(current_user),0)
      @closed_cases_by_pg_rev = Graph.closed_cases_by_pg_and_closeout_type(current_user,'total_fee_received')
    else
      @final_closed_cases_by_pg = Graph.remove_arrays_less_than_or_equal_to(Graph.closed_cases_after(current_user, params[:range].to_i),0)
      @closed_cases_by_pg_rev = Graph.closed_cases_by_pg_and_closeout_type(current_user,'total_fee_received', params[:range].to_i)
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
    @total_indirect_cost = Graph.total_overhead_per_year(current_user).map {|i| i * -1 }
    @net_profit = Graph.add_arrays(@total_fee_received,@total_indirect_cost)
  end

  def revenue_by_pg
    @pgs_total_fee_received = Graph.revenue_by_practice_group_actual(current_user,'total_fee_received')
  end

  def revenue_by_fee_type
    @hourly = Graph.revenue_by_fee_type_actual(User.first,"Hourly","total_fee_received")
    @contingency = Graph.revenue_by_fee_type_actual(User.first,"Contingency","total_fee_received")
    @mixed = Graph.revenue_by_fee_type_actual(User.first,"Fixed Fee","total_fee_received")
    @fixed = Graph.revenue_by_fee_type_actual(User.first,"Mixed","total_fee_received")
  end

  def revenue_by_origination
    #Get list of all referral sources by lawfirm.
    all_referral_sources = Origination.all_referral_sources(current_user)
    amounts = []

    #Sum the total_fee_received of all closed cases by referral source,
      # => using params[:range] if provided, 3 otherwise
    all_referral_sources.each do |ref|
      amounts << Graph.closeout_amount_by_origination(current_user, ref, 'total_fee_received', params[:range] ? params[:range].to_i : 3)
    end
    final_fee_by_origination_source = all_referral_sources.zip(amounts)

    #Remove elements from the array that are less than or = to amount us Graph.method(array, amount)
    #Do not 0 amount items in array cluttering the pie chart
    @final_fee_by_origination_source = Graph.remove_arrays_less_than_or_equal_to(final_fee_by_origination_source,0)
  end

  def revenue_by_client
    #Returns array to be used in options_for_select on page.
    @clients = Client.company_and_full_names(current_user)
    #Either the params[:client] on submit, or the first client belonging to user.
    @client = Client.find_by(id: params[:client]) || current_user.lawfirm.clients.first
    @profitability = Client.client_profitability_actual(@client)
    #Average Profitability takes way too long
    @avg_profitability = Client.avg_client_profitability(Client.all_client_profitability(current_user))


    #For Client Profitability by Year
    @gross_fee_received = Graph.client_profitability_actual_by_year(@client, 'total_gross_fee_received')
    @total_recovery = Graph.client_profitability_actual_by_year(@client, 'total_recovery')
    @out_of_pocket = Graph.client_profitability_actual_by_year(@client, 'total_out_of_pocket_expenses')
    @referring_fees = Graph.client_profitability_actual_by_year(@client, 'referring_fees_paid')
    @total_fee_received = Graph.client_profitability_actual_by_year(@client, 'total_gross_fee_received')
  end

  def individual_practice_group
    @prac_group = Practicegroup.find(params[:id]).group_name

    #First Chart
    @total_recovery = Graph.closeout_by_year_pg(current_user,params[:id],'total_recovery')
    @gross_fee_received = Graph.closeout_by_year_pg(current_user,params[:id],'total_gross_fee_received')
    @out_of_pocket = Graph.closeout_by_year_pg(current_user,params[:id],'total_out_of_pocket_expenses').map {|i| i * -1}
    @referring_fees = Graph.closeout_by_year_pg(current_user,params[:id],'referring_fees_paid').map {|i| i * -1}
    @total_fee_received = Graph.closeout_by_year_pg(current_user,params[:id],'total_fee_received')

    #Second Chart
    @origination_sources = Graph.remove_arrays_less_than_or_equal_to(
                                Graph.all_origination_source_rev_pg(current_user,params[:id],'total_fee_received'),0)

    #Third Chart
    @fee_types = Graph.rev_by_fee_type_pg(current_user,params[:id],'total_fee_received')
  end

end
