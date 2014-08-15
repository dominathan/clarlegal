class GraphsController < ApplicationController
  before_action :signed_in_user
  before_action :belongs_to_firm

  def practice_group_pie
    #Step 1. Get list of all cases that are either open or closed.
            # Create arrays to hold practicegroup totals
    open_cases = Graph.open_cases(current_user)
    closed_cases = Graph.closed_cases(current_user)
    open_cases_by_pg = []
    closed_cases_by_pg = []
    #Step 2. Get list of practice groups in current user lawfirm
    lawfirm_pgs = Graph.user_practice_groups(current_user)
    pg_count = lawfirm_pgs.length
     #Step 3.  For every practice group in a lawfirm, total the number of cases that belong
              # to that practice group and is open, as well as closed
    0.upto(pg_count-1) do |n|
      open_cases_by_pg.push(open_cases.where(practice_group: lawfirm_pgs[n]).count)
      closed_cases_by_pg.push(closed_cases.where(practice_group: lawfirm_pgs[n]).count)
    end
    #Step 4. Combine the lawfirm practice group with the count..e.g.[['Med Mal', 5]]
    @final_case_closed = lawfirm_pgs.zip(closed_cases_by_pg)
    @final_case_open = lawfirm_pgs.zip(open_cases_by_pg)
  end



#---------------------- These are for open cases, aka estimated revenue -----------

  def practice_group_revenue_pie_low
    # Step 1. Get list of all cases that are either open or closed.
    #         Create arrays to hold practicegroup totals
    #         Get list of practice groups in current user lawfirm
    lawfirm_pgs = Graph.user_practice_groups(current_user)
    open_cases = Graph.open_cases(current_user)
    total_rev_per_pg_low = []
    #Step 2.  For each case in a lawfirm, sum_total ca.fee.low_estimate by practice group
    lawfirm_pgs.each do |pg|
      sum_total = 0
      open_cases.where(practice_group: pg).each do |ca|
        ca.fee.order(:created_at).last.low_estimate ?
          sum_total += ca.fee.order(:created_at).last.low_estimate : next
      end
    #Step 3.  Put each sum_total in an array [0,1,2,3,4]
      total_rev_per_pg_low << sum_total
    end
    #Step 4. Combine the sum_totals with the lawfirm names e.g. [[Med Mal, $302,032]]
    @final_low_rev = lawfirm_pgs.zip(total_rev_per_pg_low)
    #Step 5. Repeat these for medium, high, and actual estimates
    practice_group_revenue_pie_medium
    practice_group_revenue_pie_high
    practice_group_revenue_pie_actual
  end

  def practice_group_revenue_pie_medium
    lawfirm_pgs = Graph.user_practice_groups(current_user)
    open_cases = Graph.open_cases(current_user)
    total_rev_per_pg_medium = []
    lawfirm_pgs.each do |pg|
      sum_total = 0
      open_cases.where(practice_group: pg).each do |ca|
        ca.fee.order(:created_at).last.medium_estimate ?
            sum_total += ca.fee.order(:created_at).last.medium_estimate : next
      end
      total_rev_per_pg_medium << sum_total
    end
    @final_medium_rev = lawfirm_pgs.zip(total_rev_per_pg_medium)
  end

  def practice_group_revenue_pie_high
    lawfirm_pgs = Graph.user_practice_groups(current_user)
    open_cases = Graph.open_cases(current_user)
    total_rev_per_pg_high = []
    lawfirm_pgs.each do |pg|
      sum_total = 0
      open_cases.where(practice_group: pg).each do |ca|
        ca.fee.order(:created_at).last.high_estimate ?
            sum_total += ca.fee.order(:created_at).last.high_estimate : next
      end
      total_rev_per_pg_high << sum_total
    end
    @final_high_rev = lawfirm_pgs.zip(total_rev_per_pg_high)
  end

#----------------------End Open Cases-----------------------------------------

#---------------------Closed Cases by Practice Group Pie-- AKA Actual Revenue-

  def practice_group_revenue_pie_actual
    actual_revenue_by_year
    lawfirm_pgs = Graph.user_practice_groups(current_user)
    closed_cases = Graph.closed_cases(current_user)
    total_rev_per_pg_actual = []
    lawfirm_pgs.each do |pg|
      sum_total = 0
      closed_cases.where(practice_group: pg).each do |ca|
        ca.closeouts ?
              sum_total += ca.closeouts.order(:created_at).last.total_fee_received : next
      end
      total_rev_per_pg_actual << sum_total
    end
    @final_actual_rev_by_pg = lawfirm_pgs.zip(total_rev_per_pg_actual)
  end

#--------------End practice_group_revenue_pie_charts---------------------------

#--------------Actual_Revenue_By_Year -----------------------------------------

  def actual_revenue_by_year
    #Get List of Closed Cases.  Set Variables
    closed_cases = Graph.closed_cases(current_user)
    set_yearly_revenue_variables
    #For each Closed case, call closeout_amounts (see below)
    closed_cases.each do |ca|
      closeout_amounts(ca,'total_recovery')
    end
    #Set variable = to closeout_amount return variable
    @final_total_recovery = @final
    #restart....repeat all the way down
    set_yearly_revenue_variables
    closed_cases.each do |ca|
      closeout_amounts(ca,'total_gross_fee_received')
    end
    @final_total_gross_fee_received = @final
    set_yearly_revenue_variables
    closed_cases.each do |ca|
      closeout_amounts(ca,'total_out_of_pocket_expenses')
    end
    @total_out_of_pocket_expenses = @final
    #set all elements in variable negative because it is an expense
    @total_out_of_pocket_expenses = @total_out_of_pocket_expenses.collect { |num| num*-1 }
    set_yearly_revenue_variables
    closed_cases.each do |ca|
      closeout_amounts(ca,'referring_fees_paid')
    end
    @referring_fees_paid = @final
    @referring_fees_paid = @referring_fees_paid.collect {|num| num*-1 }
    set_yearly_revenue_variables
    closed_cases.each do |ca|
      closeout_amounts(ca,'total_fee_received')
    end
    @total_fee_received = @final
  end

  def closeout_amounts(case_name,amount_type)
    #get list of 5 years leading up to most recent date fee received
    category_years = Graph.closeout_years
    #check if the closeoutform .date_fee_receveived is not false
    if case_name.closeouts.last.date_fee_received
      #set date recevied = to date fee received
      date_received = case_name.closeouts.last.date_fee_received.year
    end
    #see method below
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
    #put all elements into a @final variable that match yearly revenue
    @final = [@rev_est_year1,@rev_est_year2,@rev_est_year3,@rev_est_year4,@rev_est_year5_plus]
  end

  def closeout_amount_type(case_name,amount_type)
    #to set all amount_types possible in Closeout Table
    if amount_type == 'total_recovery'
      case_name.closeouts.last.total_recovery
    elsif amount_type == 'total_gross_fee_received'
      case_name.closeouts.last.total_gross_fee_received
    elsif amount_type == "total_out_of_pocket_expenses"
      case_name.closeouts.last.total_out_of_pocket_expenses
    elsif amount_type == "referring_fees_paid"
      case_name.closeouts.last.referring_fees_paid
    elsif amount_type == "total_fee_received"
      case_name.closeouts.last.total_fee_received
    end
  end

  def set_yearly_revenue_variables
    @rev_est_year1 = 0
    @rev_est_year2 = 0
    @rev_est_year3 = 0
    @rev_est_year4 = 0
    @rev_est_year5_plus = 0
  end

#--------------End Actual Revenue By Year--------------------------------------
#--------------Expected/Estimated Revenue By Year By Practice Group------------

  def rev_by_year_by_pg
    @lawfirm_pgs = Graph.user_practice_groups(current_user)
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    @final_tally =[]
    @lawfirm_pgs.each do |lf_pg|
      rev_est_year1 = 0
      rev_est_year2 = 0
      rev_est_year3 = 0
      rev_est_year4 = 0
      rev_est_year5_plus = 0
      current_user.lawfirm.cases.where(practice_group: lf_pg).each do |ca|
        ca.timing.first ? conclusion_date = current_date.to_time.advance(:months => (ca.timing.first.estimated_conclusion_expected)) : next
        if ca.fee.first
          if current_date.year == conclusion_date.year
            rev_est_year1 += ca.fee.first.medium_estimate
          elsif current_date.year+1 == conclusion_date.year
            rev_est_year2 += ca.fee.first.medium_estimate
          elsif current_date.year+2 == conclusion_date.year
            rev_est_year3 += ca.fee.first.medium_estimate
          elsif current_date.year+3 == conclusion_date.year
            rev_est_year4 += ca.fee.first.medium_estimate
          elsif current_date.year+4 >= conclusion_date.year
            rev_est_year5_plus += ca.fee.first.medium_estimate
          end
        else
          next
        end
        @five_year_rev = [rev_est_year1, rev_est_year2, rev_est_year3, rev_est_year4, rev_est_year5_plus]
      end
      @final_tally.push(@five_year_rev)
    end
    @final_tally
    zipped_file = @lawfirm_pgs.zip(@final_tally)
    @hash_file = zipped_file.map {|name,values| {'name' => name, 'data'  => values } }.to_json
  end

    def rev_by_year_by_pg_high
    @lawfirm_pgs = Graph.user_practice_groups(current_user)
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    @final_tally =[]
    @lawfirm_pgs.each do |lf_pg|
      rev_est_year1 = 0
      rev_est_year2 = 0
      rev_est_year3 = 0
      rev_est_year4 = 0
      rev_est_year5_plus = 0
      current_user.lawfirm.cases.where(practice_group: lf_pg).each do |ca|
        ca.timing.first ? conclusion_date = current_date.to_time.advance(:months => (ca.timing.first.estimated_conclusion_expected)) : next
        if ca.fee.first
          if current_date.year == conclusion_date.year
            rev_est_year1 += ca.fee.first.high_estimate
          elsif current_date.year+1 == conclusion_date.year
            rev_est_year2 += ca.fee.first.high_estimate
          elsif current_date.year+2 == conclusion_date.year
            rev_est_year3 += ca.fee.first.high_estimate
          elsif current_date.year+3 == conclusion_date.year
            rev_est_year4 += ca.fee.first.high_estimate
          elsif current_date.year+4 >= conclusion_date.year
            rev_est_year5_plus += ca.fee.first.high_estimate
          end
        else
          next
        end
        @five_year_rev = [rev_est_year1, rev_est_year2, rev_est_year3, rev_est_year4, rev_est_year5_plus]
      end
      @final_tally.push(@five_year_rev)
    end
    @final_tally
    zipped_file = @lawfirm_pgs.zip(@final_tally)
    @hash_file_high = zipped_file.map {|name,values| {'name' => name, 'data'  => values } }.to_json
  end

  def rev_by_year_by_pg_low
    @lawfirm_pgs = Graph.user_practice_groups(current_user)
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    @final_tally =[]
    @lawfirm_pgs.each do |lf_pg|
      rev_est_year1 = 0
      rev_est_year2 = 0
      rev_est_year3 = 0
      rev_est_year4 = 0
      rev_est_year5_plus = 0
      current_user.lawfirm.cases.where(practice_group: lf_pg).each do |ca|
        ca.timing.first ? conclusion_date = current_date.to_time.advance(:months => (ca.timing.first.estimated_conclusion_expected)) : next
        if ca.fee.first
          if current_date.year == conclusion_date.year
            rev_est_year1 += ca.fee.first.low_estimate
          elsif current_date.year+1 == conclusion_date.year
            rev_est_year2 += ca.fee.first.low_estimate
          elsif current_date.year+2 == conclusion_date.year
            rev_est_year3 += ca.fee.first.low_estimate
          elsif current_date.year+3 == conclusion_date.year
            rev_est_year4 += ca.fee.first.low_estimate
          elsif current_date.year+4 >= conclusion_date.year
            rev_est_year5_plus += ca.fee.first.low_estimate
          end
        else
          next
        end
        @five_year_rev = [rev_est_year1, rev_est_year2, rev_est_year3, rev_est_year4, rev_est_year5_plus]
      end
      @final_tally.push(@five_year_rev)
    end
    @final_tally
    zipped_file = @lawfirm_pgs.zip(@final_tally)
    @hash_file_low = zipped_file.map {|name,values| {'name' => name, 'data'  => values } }.to_json
  end
#---------------End Estimated/Expected Revenue by Year by PracticeGroup---------


#---------------BEGIN Estimated/Actual Revenue by Referral Source -----------------------
  def actual_revenue_by_referral_source
    closed_cases = Graph.closed_cases(current_user)
    all_referral_sources = Origination.all_referral_sources(current_user)
    array_of_fee_received = []
    all_referral_sources.each do |ref_source|
      sum_total = 0
      closed_cases.each do |ca|
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
    @final_fee_by_referral_source = all_referral_sources.zip(array_of_fee_received)
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
        if ca.originations.order(:created_at).last.referral_source
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
        if ca.originations.order(:created_at).last.referral_source
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
    open_cases = Graph.open_cases(current_user)
    all_referral_sources = Origination.all_referral_sources(current_user)
    array_of_fee_received = []
    all_referral_sources.each do |ref_source|
      sum_total = 0
      open_cases.each do |ca|
        if ca.originations.order(:created_at).last.referral_source
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



