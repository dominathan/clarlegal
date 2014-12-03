class GraphIndividualPracGroupsController < ApplicationController


  def expected_individual_pg_rev
    prac_group = Practicegroup.find(params[:id]).group_name
    open_cases = Graph.open_cases(current_user)
    current_date = DateTime.now
    @category_year = Graph.expected_year_only
    @lawfirm_pg_rev = []
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = Graph.time_to_collection(ca,'expected') : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"low")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"low")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"low")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"low")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"low")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev << rev_est
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = Graph.time_to_collection(ca,'expected') : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"medium")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"medium")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"medium")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"medium")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"medium")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev << rev_est
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = Graph.time_to_collection(ca,'expected') : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"high")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"high")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"high")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"high")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"high")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev << rev_est
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = Graph.time_to_collection(ca,'expected') : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"cost")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"cost")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"cost")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"cost")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"cost")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev << rev_est.collect {|amount| amount*-1}
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = Graph.time_to_collection(ca,'expected') : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"referral")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"referral")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"referral")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"referral")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"referral")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev << rev_est.collect {|amount| amount*-1}
    #the following 5 lines are to make the first 3 positions in the array subtract the last two
    #this is to make it net fee instead of gross fee
    a = @lawfirm_pg_rev
    a[0] = Graph.add_arrays(a[0],Graph.add_arrays(a[3],a[4]))
    a[1] = Graph.add_arrays(a[1],Graph.add_arrays(a[3],a[4]))
    a[2] = Graph.add_arrays(a[2],Graph.add_arrays(a[3],a[4]))
    @lawfirm_pg_rev = a
    actual_indivual_pg_revenue
    actual_indiv_pg_revenue_by_referral_source
    accelerated_individual_pg_rev
    slow_individual_pg_rev
  end
#---------------------Begin Accelerated Revenue by PG---------------------------------
  def accelerated_individual_pg_rev
    prac_group = Practicegroup.find(params[:id]).group_name
    open_cases = Graph.open_cases(current_user)
    current_date = DateTime.now
    @category_years = Graph.expected_year_only
    @lawfirm_pg_rev_accelerated = []
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = Graph.time_to_collection(ca,'fast') : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"low")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"low")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"low")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"low")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"low")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev_accelerated << rev_est
    #for medium estimate
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = Graph.time_to_collection(ca,'fast') : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"medium")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"medium")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"medium")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"medium")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"medium")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev_accelerated << rev_est
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = Graph.time_to_collection(ca,'fast') : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"high")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"high")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"high")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"high")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"high")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev_accelerated << rev_est
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = Graph.time_to_collection(ca,'fast') : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"cost")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"cost")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"cost")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"cost")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"cost")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev_accelerated << rev_est.collect {|amount| amount*-1}
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = Graph.time_to_collection(ca,'fast') : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"referral")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"referral")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"referral")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"referral")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"referral")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev_accelerated << rev_est.collect {|amount| amount*-1}
    #the following 5 lines are to make the first 3 positions in the array subtract the last two
    #this is to make it net fee instead of gross fee
    a = @lawfirm_pg_rev_accelerated
    a[0] = Graph.add_arrays(a[0],Graph.add_arrays(a[3],a[4]))
    a[1] = Graph.add_arrays(a[1],Graph.add_arrays(a[3],a[4]))
    a[2] = Graph.add_arrays(a[2],Graph.add_arrays(a[3],a[4]))
    @lawfirm_pg_rev_accelerated = a
  end
#--------------------Begin Slow Collection by PG-----------------------
  def slow_individual_pg_rev
    prac_group = Practicegroup.find(params[:id]).group_name
    open_cases = Graph.open_cases(current_user)
    current_date = DateTime.now
    @category_years = Graph.expected_year_only
    @lawfirm_pg_rev_slow = []
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = Graph.time_to_collection(ca,'slow') : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"low")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"low")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"low")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"low")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"low")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev_slow << rev_est
    #for medium estimate
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = Graph.time_to_collection(ca,'slow') : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"medium")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"medium")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"medium")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"medium")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"medium")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev_slow << rev_est
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = Graph.time_to_collection(ca,'slow') : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"high")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"high")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"high")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"high")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"high")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev_slow << rev_est
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = Graph.time_to_collection(ca,'slow') : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"cost")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"cost")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"cost")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"cost")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"cost")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev_slow << rev_est.collect {|amount| amount*-1}
    rev_est = set_yearly_rev_array
    open_cases.where(practice_group: prac_group).each do |ca|
      ca.timing.order(:created_at).last ? conclusion_date = Graph.time_to_collection(ca,'slow') : next
      if ca.fee.order(:created_at).last
        if current_date.year == conclusion_date.year
          rev_est[0] += Graph.collection_expectation(ca,"referral")
        elsif current_date.year+1 == conclusion_date.year
          rev_est[1] += Graph.collection_expectation(ca,"referral")
        elsif current_date.year+2 == conclusion_date.year
          rev_est[2] += Graph.collection_expectation(ca,"referral")
        elsif current_date.year+3 == conclusion_date.year
          rev_est[3] += Graph.collection_expectation(ca,"referral")
        elsif current_date.year+4 >= conclusion_date.year
          rev_est[4] += Graph.collection_expectation(ca,"referral")
        end
      else
        next
      end
    end
    @lawfirm_pg_rev_slow << rev_est.collect {|amount| amount*-1}
    #the following 5 lines are to make the first 3 positions in the array subtract the last two
    #this is to make it net fee instead of gross fee
    a = @lawfirm_pg_rev_slow
    a[0] = Graph.add_arrays(a[0],Graph.add_arrays(a[3],a[4]))
    a[1] = Graph.add_arrays(a[1],Graph.add_arrays(a[3],a[4]))
    a[2] = Graph.add_arrays(a[2],Graph.add_arrays(a[3],a[4]))
    @lawfirm_pg_rev_slow = a
  end


#---------------------Begin Actual Revenue by PG--------------------------------------
  def actual_indivual_pg_revenue
    prac_group = Practicegroup.find(params[:id]).group_name
    closed_cases = Graph.closed_cases(current_user)
    set_yearly_revenue_variables
    @category_years_backwards = Graph.closeout_year_only
    @lawfirm_pg_rev_actual = []
    rev_est = set_yearly_rev_array
    if closed_cases.where(practice_group: prac_group).any?
      closed_cases.where(practice_group: prac_group).each do |ca|
        closeout_amounts(ca,'total_recovery')
      end
      @total_recovery = @final
    else
      @total_recovery = [0,0,0,0,0]
    end
    set_yearly_revenue_variables
    if closed_cases.where(practice_group: prac_group).any?
      closed_cases.where(practice_group: prac_group).each do |ca|
        closeout_amounts(ca,'total_gross_fee_received')
      end
      @gross_fee_received = @final
    else
      @gross_fee_received = [0,0,0,0,0]
    end
    set_yearly_revenue_variables
    if closed_cases.where(practice_group: prac_group).any?
      closed_cases.where(practice_group: prac_group).each do |ca|
        closeout_amounts(ca,'total_out_of_pocket_expenses')
      end
      @out_of_pocket_expenses = @final.each.collect { |amount| amount*-1 }
    else
      @out_of_pocket_expenses = [0,0,0,0,0]
    end
    set_yearly_revenue_variables
    if closed_cases.where(practice_group: prac_group).any?
      closed_cases.where(practice_group: prac_group).each do |ca|
        closeout_amounts(ca,'referring_fees_paid')
      end
      @referring_fees_paid = @final.each.collect { |amount| amount*-1 }
    else
      @referring_fees_paid = [0,0,0,0,0]
    end
    set_yearly_revenue_variables
    if closed_cases.where(practice_group: prac_group).any?
      closed_cases.where(practice_group: prac_group).each do |ca|
        closeout_amounts(ca,'total_fee_received')
      end
      @total_fee_received = @final
    else
      @total_fee_received = [0,0,0,0,0]
    end
  end

  def closeout_amounts(case_name,amount_type)
    #get list of 5 years leading up to most recent date fee received
    category_years = Graph.closeout_years
    #check if the closeoutform .date_fee_receveived is not false
    if case_name.closeouts.last.date_fee_received
      #set date recevied = to date fee received
      date_received = case_name.closeouts.order(:created_at).last.date_fee_received.year
    end
    #see method below
    if case_name.closeouts.last
      if closeout_amount_type(case_name,amount_type)
        #augment variable by the amount_type if years match
        if date_received == category_years[0]
          @rev_est_year1 += closeout_amount_type(case_name,amount_type)
        elsif date_received == category_years[1]
          @rev_est_year2 += closeout_amount_type(case_name,amount_type)
        elsif date_received == category_years[2]
          @rev_est_year3 += closeout_amount_type(case_name,amount_type)
        elsif date_received == category_years[3]
          @rev_est_year4 += closeout_amount_type(case_name,amount_type)
        elsif date_received == category_years[4]
          @rev_est_year5_plus += closeout_amount_type(case_name,amount_type)
        end
      end
    end
    #put all elements into a @final variable that match yearly revenue
    @final = [@rev_est_year1,@rev_est_year2,@rev_est_year3,@rev_est_year4,@rev_est_year5_plus]
  end

  def closeout_amount_type(case_name,amount_type)
    #to set all amount_types possible in Closeout Table
    if case_name.closeouts.order(:created_at).last
      if amount_type == 'total_recovery'
        case_name.closeouts.last.total_recovery ? case_name.closeouts.last.total_recovery : 0
      elsif amount_type == 'total_gross_fee_received'
        case_name.closeouts.last.total_gross_fee_received ? case_name.closeouts.last.total_gross_fee_received : 0
      elsif amount_type == "total_out_of_pocket_expenses"
        case_name.closeouts.last.total_out_of_pocket_expenses ? case_name.closeouts.last.total_out_of_pocket_expenses : 0
      elsif amount_type == "referring_fees_paid"
        case_name.closeouts.last.referring_fees_paid ? case_name.closeouts.last.referring_fees_paid : 0
      elsif amount_type == "total_fee_received"
        case_name.closeouts.last.total_fee_received ? case_name.closeouts.last.total_fee_received : 0
      end
    else
      return 0
    end
  end

  def set_yearly_revenue_variables
    @rev_est_year1 = 0
    @rev_est_year2 = 0
    @rev_est_year3 = 0
    @rev_est_year4 = 0
    @rev_est_year5_plus = 0
  end


  def set_yearly_rev_array
    [rev_est_year1 = 0, rev_est_year2 = 0, rev_est_year3 = 0, rev_est_year4 = 0, rev_est_year5_plus = 0]
  end

  #------------------END --------------------------------

  #---------------Individual PG Rev by Referral Source -----------------


  def actual_indiv_pg_revenue_by_referral_source
    closed_cases = Graph.closed_cases(current_user)
    prac_group = Practicegroup.find(params[:id]).group_name
    all_referral_sources = Origination.all_referral_sources(current_user)
    array_of_fee_received = []
    all_referral_sources.each do |ref_source|
      sum_total = 0
      closed_cases.where(practice_group: prac_group).each do |ca|
        if ca.originations.order(:created_at).last.referral_source
          if ca.originations.order(:created_at).last.referral_source == ref_source
            sum_total += ca.closeouts.order(:created_at).last.total_fee_received
          end
        else
          next
        end
      end
      array_of_fee_received << sum_total
    end
    @final_indiv_pg_fee_by_referral_source_actual = all_referral_sources.zip(array_of_fee_received)
  end

#--------------------------------------------------------------------------------

end
