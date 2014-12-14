class GraphIndividualPracGroupsController < ApplicationController
  before_action :signed_in_user, :belongs_to_firm, :has_open_cases

  def expected_individual_pg_rev
    @high_fast = Graph.fee_estimate_by_year_by_pg(current_user,params[:id],'estimated_conclusion_fast','high_estimate')
    @med_fast = Graph.fee_estimate_by_year_by_pg(current_user,params[:id],'estimated_conclusion_fast','medium_estimate')
    @low_fast = Graph.fee_estimate_by_year_by_pg(current_user,params[:id],'estimated_conclusion_fast','low_estimate')
    @cost_fast = Graph.fee_estimate_by_year_by_pg(current_user,params[:id],'estimated_conclusion_fast','cost_estimate').map {|i| i * -1}
    #@retainer_fast = Graph.fee_estimate_by_year_by_pg(current_user,params[:id],'estimated_conclusion_fast','retainer')
    @referral_fast = Graph.fee_estimate_by_year_by_pg(current_user,params[:id],'estimated_conclusion_fast','referral').map {|i| i * -1}


    @high_expected = Graph.fee_estimate_by_year_by_pg(current_user,params[:id],'estimated_conclusion_expected','high_estimate')
    @med_expected = Graph.fee_estimate_by_year_by_pg(current_user,params[:id],'estimated_conclusion_expected','medium_estimate')
    @low_expected = Graph.fee_estimate_by_year_by_pg(current_user,params[:id],'estimated_conclusion_expected','low_estimate')
    @cost_expected = Graph.fee_estimate_by_year_by_pg(current_user,params[:id],'estimated_conclusion_expected','cost_estimate').map {|i| i * -1}
    #@retainer_expected = Graph.fee_estimate_by_year_by_pg(current_user,params[:id],'estimated_conclusion_expected','retainer')
    @referral_expected = Graph.fee_estimate_by_year_by_pg(current_user,params[:id],'estimated_conclusion_expected','referral').map {|i| i * -1}


    @high_slow = Graph.fee_estimate_by_year_by_pg(current_user,params[:id],'estimated_conclusion_slow','high_estimate')
    @med_slow = Graph.fee_estimate_by_year_by_pg(current_user,params[:id],'estimated_conclusion_slow','medium_estimate')
    @low_slow = Graph.fee_estimate_by_year_by_pg(current_user,params[:id],'estimated_conclusion_slow','low_estimate')
    @cost_slow = Graph.fee_estimate_by_year_by_pg(current_user,params[:id],'estimated_conclusion_slow','cost_estimate').map {|i| i * -1}
    #@retainer_slow = Graph.fee_estimate_by_year_by_pg(current_user,params[:id],'estimated_conclusion_slow','retainer')
    @referral_slow = Graph.fee_estimate_by_year_by_pg(current_user,params[:id],'estimated_conclusion_slow','referral').map {|i| i * -1}

    @total_recovery = Graph.closeout_by_year_pg(current_user,params[:id],'total_recovery')
    @gross_fee_received = Graph.closeout_by_year_pg(current_user,params[:id],'total_gross_fee_received')
    @out_of_pocket = Graph.closeout_by_year_pg(current_user,params[:id],'total_out_of_pocket_expenses').map {|i| i * -1}
    @referring_fees = Graph.closeout_by_year_pg(current_user,params[:id],'referring_fees_paid').map {|i| i * -1}
    @total_fee_received = Graph.closeout_by_year_pg(current_user,params[:id],'total_fee_received')

    @origination_source_med = Graph.all_origination_source_fee_estimate_pg(current_user,params[:id],"medium_estimate")

    @fee_types_med = Graph.fee_estimate_by_fee_type_pg(current_user,params[:id],"medium_estimate","estimated_conclusion_expected")
  end
#---------------------Begin Accelerated Revenue by PG---------------------------------

end
