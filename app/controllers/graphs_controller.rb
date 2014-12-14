class GraphsController < ApplicationController
  before_action :signed_in_user, :belongs_to_firm, :has_open_cases

  def practice_group_pie
    open_cases_by_pg = Graph.open_cases_by_pg(current_user)
    @final_case_open = Graph.remove_arrays_less_than_or_equal_to(open_cases_by_pg,0)
  end

  def practice_group_revenue_pie_low
    @final_low_rev = Graph.open_cases_by_pg_and_fee_estimate(current_user,"low_estimate")
    @final_medium_rev = Graph.open_cases_by_pg_and_fee_estimate(current_user,"medium_estimate")
    @final_high_rev = Graph.open_cases_by_pg_and_fee_estimate(current_user,"high_estimate")
  end

#--------------Expected/Estimated Revenue By Year By Practice Group------------

  def rev_by_year_by_pg
    @medium_fee_expected_conclusion = Graph.revenue_by_practice_group_estimated(current_user,'medium_estimate','estimated_conclusion_expected')
    @medium_fee_accelerated_conclusion = Graph.revenue_by_practice_group_estimated(current_user,'medium_estimate',"estimated_conclusion_fast")
    @medium_fee_slow_conclusion = Graph.revenue_by_practice_group_estimated(current_user,'medium_estimate',"estimated_conclusion_slow")
  end

  def rev_by_year_by_pg_high
    @high_fee_expected_conclusion = Graph.revenue_by_practice_group_estimated(current_user,'high_estimate','estimated_conclusion_expected')
    @high_fee_accelerated_conclusion = Graph.revenue_by_practice_group_estimated(current_user,'high_estimate',"estimated_conclusion_fast")
    @high_fee_slow_conclusion = Graph.revenue_by_practice_group_estimated(current_user,'high_estimate',"estimated_conclusion_slow")

  end

  def rev_by_year_by_pg_low
    @low_fee_expected_conclusion = Graph.revenue_by_practice_group_estimated(current_user,'low_estimate','estimated_conclusion_expected')
    @low_fee_accelerated_conclusion = Graph.revenue_by_practice_group_estimated(current_user,'low_estimate',"estimated_conclusion_fast")
    @low_fee_slow_conclusion = Graph.revenue_by_practice_group_estimated(current_user,'low_estimate',"estimated_conclusion_slow")
  end


#---------------End Estimated/Expected Revenue by Year by PracticeGroup---------
  def rev_by_fee_type_medium
    @contingency_expected = Graph.revenue_by_fee_type_estimated(current_user,"Contingency",'estimated_conclusion_expected','medium_estimate')
    @mixed_expected = Graph.revenue_by_fee_type_estimated(current_user,"Mixed",'estimated_conclusion_expected','medium_estimate')
    @fixed_fee_expected = Graph.revenue_by_fee_type_estimated(current_user,"Fixed Fee",'estimated_conclusion_expected','medium_estimate')
    @hourly_expected = Graph.revenue_by_fee_type_estimated(current_user,"Hourly",'estimated_conclusion_expected','medium_estimate')

    @contingency_fast = Graph.revenue_by_fee_type_estimated(current_user,"Contingency",'estimated_conclusion_fast','medium_estimate')
    @mixed_fast = Graph.revenue_by_fee_type_estimated(current_user,"Mixed",'estimated_conclusion_fast','medium_estimate')
    @fixed_fee_fast = Graph.revenue_by_fee_type_estimated(current_user,"Fixed Fee",'estimated_conclusion_fast','medium_estimate')
    @hourly_fast = Graph.revenue_by_fee_type_estimated(current_user,"Hourly",'estimated_conclusion_fast','medium_estimate')

    @contingency_slow = Graph.revenue_by_fee_type_estimated(current_user,"Contingency",'estimated_conclusion_slow','medium_estimate')
    @mixed_slow = Graph.revenue_by_fee_type_estimated(current_user,"Mixed",'estimated_conclusion_slow','medium_estimate')
    @fixed_fee_slow = Graph.revenue_by_fee_type_estimated(current_user,"Fixed Fee",'estimated_conclusion_slow','medium_estimate')
    @hourly_slow = Graph.revenue_by_fee_type_estimated(current_user,"Hourly",'estimated_conclusion_slow','medium_estimate')
  end

  def rev_by_fee_type_low
    @contingency_expected = Graph.revenue_by_fee_type_estimated(current_user,"Contingency",'estimated_conclusion_expected','low_estimate')
    @mixed_expected = Graph.revenue_by_fee_type_estimated(current_user,"Mixed",'estimated_conclusion_expected','low_estimate')
    @fixed_fee_expected = Graph.revenue_by_fee_type_estimated(current_user,"Fixed Fee",'estimated_conclusion_expected','low_estimate')
    @hourly_expected = Graph.revenue_by_fee_type_estimated(current_user,"Hourly",'estimated_conclusion_expected','low_estimate')

    @contingency_fast = Graph.revenue_by_fee_type_estimated(current_user,"Contingency",'estimated_conclusion_fast','low_estimate')
    @mixed_fast = Graph.revenue_by_fee_type_estimated(current_user,"Mixed",'estimated_conclusion_fast','low_estimate')
    @fixed_fee_fast = Graph.revenue_by_fee_type_estimated(current_user,"Fixed Fee",'estimated_conclusion_fast','low_estimate')
    @hourly_fast = Graph.revenue_by_fee_type_estimated(current_user,"Hourly",'estimated_conclusion_fast','low_estimate')

    @contingency_slow = Graph.revenue_by_fee_type_estimated(current_user,"Contingency",'estimated_conclusion_slow','low_estimate')
    @mixed_slow = Graph.revenue_by_fee_type_estimated(current_user,"Mixed",'estimated_conclusion_slow','low_estimate')
    @fixed_fee_slow = Graph.revenue_by_fee_type_estimated(current_user,"Fixed Fee",'estimated_conclusion_slow','low_estimate')
    @hourly_slow = Graph.revenue_by_fee_type_estimated(current_user,"Hourly",'estimated_conclusion_slow','low_estimate')
  end

  def rev_by_fee_type_high
    @contingency_expected = Graph.revenue_by_fee_type_estimated(current_user,"Contingency",'estimated_conclusion_expected','high_estimate')
    @mixed_expected = Graph.revenue_by_fee_type_estimated(current_user,"Mixed",'estimated_conclusion_expected','high_estimate')
    @fixed_fee_expected = Graph.revenue_by_fee_type_estimated(current_user,"Fixed Fee",'estimated_conclusion_expected','high_estimate')
    @hourly_expected = Graph.revenue_by_fee_type_estimated(current_user,"Hourly",'estimated_conclusion_expected','high_estimate')

    @contingency_fast = Graph.revenue_by_fee_type_estimated(current_user,"Contingency",'estimated_conclusion_fast','high_estimate')
    @mixed_fast = Graph.revenue_by_fee_type_estimated(current_user,"Mixed",'estimated_conclusion_fast','high_estimate')
    @fixed_fee_fast = Graph.revenue_by_fee_type_estimated(current_user,"Fixed Fee",'estimated_conclusion_fast','high_estimate')
    @hourly_fast = Graph.revenue_by_fee_type_estimated(current_user,"Hourly",'estimated_conclusion_fast','high_estimate')

    @contingency_slow = Graph.revenue_by_fee_type_estimated(current_user,"Contingency",'estimated_conclusion_slow','high_estimate')
    @mixed_slow = Graph.revenue_by_fee_type_estimated(current_user,"Mixed",'estimated_conclusion_slow','high_estimate')
    @fixed_fee_slow = Graph.revenue_by_fee_type_estimated(current_user,"Fixed Fee",'estimated_conclusion_slow','high_estimate')
    @hourly_slow = Graph.revenue_by_fee_type_estimated(current_user,"Hourly",'estimated_conclusion_slow','high_estimate')
  end

#---------------BEGIN Estimated/Actual Revenue by Referral Source -----------------------
  def fee_received_by_referral_medium
    #Get list of all referral sources by lawfirm.
    all_referral_sources = Origination.all_referral_sources(current_user)
    amounts = []

    #Sum the total_fee_received of all closed cases by referral source,
      # => using params[:range] if provided, 3 otherwise
    all_referral_sources.each do |ref|
      amounts << Graph.fee_estimate_by_origination(current_user, ref, 'medium_estimate')
    end
    final_fee_by_origination_source = all_referral_sources.zip(amounts)

    #Remove elements from the array that are less than or = to amount us Graph.method(array, amount)
    #Do not 0 amount items in array cluttering the pie chart
    @fee_by_origination_source_medium = Graph.remove_arrays_less_than_or_equal_to(final_fee_by_origination_source,0)

    #Repeat for High and Low Fee Estimates
    amounts = []
    all_referral_sources.each do |ref|
      amounts << Graph.fee_estimate_by_origination(current_user, ref, 'high_estimate')
    end
    final_fee_by_origination_source = all_referral_sources.zip(amounts)
    @fee_by_origination_source_high = Graph.remove_arrays_less_than_or_equal_to(final_fee_by_origination_source,0)

    amounts = []
    all_referral_sources.each do |ref|
      amounts << Graph.fee_estimate_by_origination(current_user, ref, 'low_estimate')
    end
    final_fee_by_origination_source = all_referral_sources.zip(amounts)
    @fee_by_origination_source_low = Graph.remove_arrays_less_than_or_equal_to(final_fee_by_origination_source,0)
  end


end



