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

#-----------------Rev by PG at Accelerated Recovery---------------------#

#---------------End Estimated/Expected Revenue by Year by PracticeGroup---------


#---------------BEGIN Estimated/Actual Revenue by Referral Source -----------------------
  def actual_revenue_by_referral_source
    #Get list of all referral sources by lawfirm.
    all_referral_sources = Origination.all_referral_sources(current_user)
    amounts = []

    #Sum the total_fee_received of all closed cases by referral source
    all_referral_sources.each do |ref|
      amounts << Graph.closeout_amount_by_origination(current_user, ref, 'total_fee_received')
    end
    @final_fee_by_referral_source = all_referral_sources.zip(amounts)

    #Remove elements from the array that are less than or = to amount us Graph.method(array, amount)
    #Do not 0 amount items in array cluttering the pie chart
    @final_fee_by_referral_source = Graph.remove_arrays_less_than_or_equal_to(@final_fee_by_referral_source,0)

    #All others are expected values and need to be reworked
    expected_revenue_by_referral_source
    low_revenue_by_referral_source
    high_revenue_by_referral_source
  end

  def expected_revenue_by_referral_source
    open_cases = Graph.open_cases(current_user)
    all_referral_sources = Origination.all_referral_sources(current_user)
    array_of_fee_received = []
    all_referral_sources.each do |ref_source|
      sum_total = 0
      open_cases.each do |ca|
        if ca.originations.order(:created_at).last
          if ca.originations.order(:created_at).last.referral_source == ref_source
            sum_total += ca.fees.order(:created_at).last.medium_estimate
          end
        else
          next
        end
      end
      array_of_fee_received << sum_total
    end
    @final_fee_by_referral_source_expected = all_referral_sources.zip(array_of_fee_received)
  end

  def low_revenue_by_referral_source
    open_cases = Graph.open_cases(current_user)
    all_referral_sources = Origination.all_referral_sources(current_user)
    array_of_fee_received = []
    all_referral_sources.each do |ref_source|
      sum_total = 0
      open_cases.each do |ca|
        if ca.originations.order(:created_at).last
          if ca.originations.order(:created_at).last.referral_source == ref_source
            sum_total += ca.fees.order(:created_at).last.low_estimate
          end
        else
          next
        end
      end
      array_of_fee_received << sum_total
    end
    @final_fee_by_referral_source_low = all_referral_sources.zip(array_of_fee_received)
  end

  def high_revenue_by_referral_source
    all_referral_sources = Origination.all_referral_sources(current_user)
    array_of_fee_received = []
    all_referral_sources.each do |ref_source|
      sum_total = 0
      current_user.lawfirm.cases.where(open: true).each do |ca|
        if ca.originations.order(:created_at).last
          if ca.originations.order(:created_at).last.referral_source == ref_source
            sum_total += ca.fees.order(:created_at).last.high_estimate
          end
        else
          next
        end
      end
      array_of_fee_received << sum_total
    end
    @final_fee_by_referral_source_high = all_referral_sources.zip(array_of_fee_received)
  end


#---------------END Estimated/Actual Revenue by Referral Source -----------------------

end



