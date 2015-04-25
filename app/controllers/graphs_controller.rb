class GraphsController < ApplicationController
  before_action :signed_in_user, :belongs_to_firm
  before_action :has_open_cases, except: [:dashboard]

  def dashboard
    #boxes
    @year_to_date = Graph.actual_amount_earned_time_frame(current_user,'total_fee_received',Date.today.beginning_of_year,Date.today)
    @year_projected_medium = Graph.projected_amount_earned_time_frame(current_user,'medium_estimate','estimated_conclusion_expected',Date.today.beginning_of_year,Date.today.end_of_year)
    @year_to_date_compared_to_last_year = @year_to_date - Graph.actual_amount_earned_time_frame(current_user,'total_fee_received',Date.today.beginning_of_year - 1.year,Date.today - 1.year)
    @trailing_twelve = Graph.actual_amount_earned_time_frame(current_user, 'total_fee_received', Date.today - 1.year, Date.today)

    #actual_graph
    @category_by_year = Graph.closeout_year_only
    @total_recovery = Graph.closeout_amount_by_year(current_user,"total_recovery")
    @total_gross_fee_received = Graph.closeout_amount_by_year(current_user,"total_gross_fee_received")
    @total_out_of_pocket_expenses =  Graph.closeout_amount_by_year(current_user,"total_out_of_pocket_expenses").map { |i| i *- 1}
    @referring_fees_paid = Graph.closeout_amount_by_year(current_user,"referring_fees_paid").map {|i| i * -1}
    @total_fee_received = Graph.closeout_amount_by_year(current_user,"total_fee_received")
    begin
        @total_indirect_cost = Graph.total_overhead_per_year(current_user).map {|i| i * -1 }
        @net_profit = Graph.add_arrays(@total_fee_received,@total_indirect_cost)
    rescue
        @total_indirect_cost = [0,0,0,0,0]
        @net_profit = [0,0,0,0,0]
    end

    #projected graph
    @projected_years = Graph.expected_year_only
    rev_by_year_high = Graph.fee_estimate_by_year(current_user,"estimated_conclusion_expected","high_estimate")
    rev_by_year_medium = Graph.fee_estimate_by_year(current_user,"estimated_conclusion_expected","medium_estimate")
    rev_by_year_low = Graph.fee_estimate_by_year(current_user,"estimated_conclusion_expected","low_estimate")
    @cost_by_year = Graph.fee_estimate_by_year(current_user,"estimated_conclusion_expected","cost_estimate").map { |x| x*-1}
    referral_by_year_high = Graph.fee_estimate_by_year(current_user,"estimated_conclusion_expected","high_referral").map { |x| x*-1}
    @referral_by_year = Graph.fee_estimate_by_year(current_user,"estimated_conclusion_expected","medium_referral").map { |x| x*-1}
    referral_by_year_low = Graph.fee_estimate_by_year(current_user,"estimated_conclusion_expected","low_referral").map { |x| x*-1}

    @rev_by_year_high = Graph.add_arrays(rev_by_year_high, Graph.add_arrays(@cost_by_year, referral_by_year_high))
    @rev_by_year_medium = Graph.add_arrays(rev_by_year_medium, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @rev_by_year_low = Graph.add_arrays(rev_by_year_low, Graph.add_arrays(@cost_by_year, referral_by_year_low))
    begin
        @overhead_by_year = Array.new(@rev_by_year_low.length, Graph.expected_overhead_next_year(current_user)).map { |x| x*-1 }
    rescue
        @overhead_by_year = [0,0,0,0,0]
    end

    #Practice Groups
    @medium_fee_expected_conclusion = Graph.revenue_by_practice_group_estimated(current_user,'medium_estimate','estimated_conclusion_expected')
  end

  def practice_group_pie
    open_cases_by_pg = Graph.open_cases_by_pg(current_user)
    @final_case_open = Graph.remove_arrays_less_than_or_equal_to(open_cases_by_pg,0)
  end

  def practice_group_revenue_pie_low
    @year = params[:range] || 3
    if params[:range] == nil
      @final_low_rev = Graph.open_cases_by_pg_and_fee_estimate(current_user,"low_estimate")
      @final_medium_rev = Graph.open_cases_by_pg_and_fee_estimate(current_user,"medium_estimate")
      @final_high_rev = Graph.open_cases_by_pg_and_fee_estimate(current_user,"high_estimate")
    else
      @final_low_rev = Graph.open_cases_by_pg_and_fee_estimate(current_user,"low_estimate",params[:range].to_i)
      @final_medium_rev = Graph.open_cases_by_pg_and_fee_estimate(current_user,"medium_estimate",params[:range].to_i)
      @final_high_rev = Graph.open_cases_by_pg_and_fee_estimate(current_user,"high_estimate",params[:range].to_i)
    end
  end

  def practice_group_revenue_pie

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

  def revenue_by_client_estimate
    #Returns array to be used in options_for_select on page.
    @clients = Client.company_and_full_names(current_user)
    #Either the params[:client] on submit, or the first client belonging to user.
    @client = Client.find_by(id: params[:client_id]) || current_user.lawfirm.clients.first


    #Expected conclusion date
    @high_estimate_expected = Graph.client_fee_estimate_by_year(@client,'high_estimate','estimated_conclusion_expected')
    @medium_estimate_expected = Graph.client_fee_estimate_by_year(@client,'medium_estimate','estimated_conclusion_expected')
    @low_estimate_expected = Graph.client_fee_estimate_by_year(@client,'low_estimate','estimated_conclusion_expected')
    @cost_estimate_expected = Graph.client_fee_estimate_by_year(@client,'cost_estimate','estimated_conclusion_expected').map { |x| x*-1 }
    @referral_expected = Graph.client_fee_estimate_by_year(@client,'medium_referral','estimated_conclusion_expected').map { |x| x*-1 }
    #Indirect Cost is the rate_per_hour (overhead) multiplied by the number of hours expected on this client
    @indirect_cost_expected = Graph.client_expected_hours_remaining(@client,'estimated_conclusion_expected').map {|x| (x*-1*current_user.lawfirm.overheads.where(year: Date.today.year).take.rate_per_hour).round(0 )}

    #Accelerated Conclusion Date
    @high_estimate_accelerated = Graph.client_fee_estimate_by_year(@client,'high_estimate','estimated_conclusion_fast')
    @medium_estimate_accelerated = Graph.client_fee_estimate_by_year(@client,'medium_estimate','estimated_conclusion_fast')
    @low_estimate_accelerated = Graph.client_fee_estimate_by_year(@client,'low_estimate','estimated_conclusion_fast')
    @cost_estimate_accelerated = Graph.client_fee_estimate_by_year(@client,'cost_estimate','estimated_conclusion_fast').map { |x| x*-1 }
    @referral_accelerated = Graph.client_fee_estimate_by_year(@client,'medium_referral','estimated_conclusion_fast').map { |x| x*-1 }
    @indirect_cost_accelerated = Graph.client_expected_hours_remaining(@client,'estimated_conclusion_fast').map {|x| (x*-1*current_user.lawfirm.overheads.where(year: Date.today.year).take.rate_per_hour).round(0 )}

    #Slow Conclusion Date
    @high_estimate_slow = Graph.client_fee_estimate_by_year(@client,'high_estimate','estimated_conclusion_slow')
    @medium_estimate_slow = Graph.client_fee_estimate_by_year(@client,'medium_estimate','estimated_conclusion_slow')
    @low_estimate_slow = Graph.client_fee_estimate_by_year(@client,'low_estimate','estimated_conclusion_slow')
    @cost_estimate_slow = Graph.client_fee_estimate_by_year(@client,'cost_estimate','estimated_conclusion_slow').map { |x| x*-1 }
    @referral_slow = Graph.client_fee_estimate_by_year(@client,'medium_referral','estimated_conclusion_slow').map { |x| x*-1 }
    @indirect_cost_slow = Graph.client_expected_hours_remaining(@client,'estimated_conclusion_slow').map {|x| (x*-1*current_user.lawfirm.overheads.where(year: Date.today.year).take.rate_per_hour).round(0 )}
  end

  def revenue_by_attorney_estimate
    @attorney = Staffing.find(params[:id])
    @high_estimate_expected = Graph.revenue_by_attorney_estimate(current_user,params[:id],'high_estimate','estimated_conclusion_expected',"Responsible Attorney")
    @medium_estimate_expected = Graph.revenue_by_attorney_estimate(current_user,params[:id],'medium_estimate','estimated_conclusion_expected',"Responsible Attorney")
    @low_estimate_expected = Graph.revenue_by_attorney_estimate(current_user,params[:id],'low_estimate','estimated_conclusion_expected',"Responsible Attorney")

    @high_estimate_accelerated = Graph.revenue_by_attorney_estimate(current_user,params[:id],'high_estimate','estimated_conclusion_fast',"Responsible Attorney")
    @medium_estimate_accelerated = Graph.revenue_by_attorney_estimate(current_user,params[:id],'medium_estimate','estimated_conclusion_fast',"Responsible Attorney")
    @low_estimate_accelerated = Graph.revenue_by_attorney_estimate(current_user,params[:id],'low_estimate','estimated_conclusion_fast',"Responsible Attorney")

    @high_estimate_slow = Graph.revenue_by_attorney_estimate(current_user,params[:id],'high_estimate','estimated_conclusion_slow',"Responsible Attorney")
    @medium_estimate_slow = Graph.revenue_by_attorney_estimate(current_user,params[:id],'medium_estimate','estimated_conclusion_slow',"Responsible Attorney")
    @low_estimate_slow = Graph.revenue_by_attorney_estimate(current_user,params[:id],'low_estimate','estimated_conclusion_slow',"Responsible Attorney")
  end

end



