class GraphsController < ApplicationController
  before_action :signed_in_user
  before_action :belongs_to_firm

  def practice_group_pie
    #Step 1. Get list of all cases that are open.
            # Create arrays to hold practicegroup totals
    open_cases = Graph.open_cases(current_user)
    open_cases_by_pg = []
    #Step 2. Get list of practice groups in current user lawfirm
    lawfirm_pgs = Graph.user_practice_groups(current_user)
    pg_count = lawfirm_pgs.length
     #Step 3.  For every practice group in a lawfirm, total the number of cases that belong
              # to that practice group and is open
    0.upto(pg_count-1) do |n|
      open_cases_by_pg.push(open_cases.where(practice_group: lawfirm_pgs[n]).count)
    end
    #Step 4. Combine the lawfirm practice group with the count..e.g.[['Med Mal', 5]]
              #practice_group_pie_actual takes the closed cases, with a number of previous year
              #look back limit
              #Remove 0 Case totals Practicegroups with Graph.remove_arrays
    @final_case_closed = Graph.remove_arrays_less_than_or_equal_to(practice_group_pie_actual,0)
    @final_case_open = Graph.remove_arrays_less_than_or_equal_to(lawfirm_pgs.zip(open_cases_by_pg),0)
  end

  def practice_group_pie_actual
    closed_cases = Graph.closed_cases_after(current_user,3)
    closed_cases_by_pg = []
    lawfirm_pgs = Graph.user_practice_groups(current_user)
    lawfirm_pgs.each do |pg|
      count = 0
      closed_cases.each do |ca|
        if ca.practice_group == pg
          count += 1
        end
      end
      closed_cases_by_pg << count
      count=0
    end
    lawfirm_pgs.zip(closed_cases_by_pg)
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
    lawfirm_pgs = Graph.user_practice_groups(current_user)
    closed_cases = Graph.closed_cases_after(current_user,3)
    total_rev_per_pg_actual = []
    lawfirm_pgs.each do |pg|
      sum_total = 0
      closed_cases.each do |ca|
        if ca.practice_group == pg
          if ca.closeouts.order(:created_at).last.total_fee_received
            sum_total += ca.closeouts.order(:created_at).last.total_fee_received
          else
            next
          end
        else
          next
        end
      end
      total_rev_per_pg_actual << sum_total
    end
    @final_actual_rev_by_pg = lawfirm_pgs.zip(total_rev_per_pg_actual)
  end

#--------------End practice_group_revenue_pie_charts---------------------------

  #Get all Closeout values belonging to User Lawfirm.  Expenses are made negative.
  #See Graph.closeamount_by_year(user,closeout.attribute) for more information.
  def actual_revenue_by_year
    #Using all 5 dollar amounts in Closeout Model for graph.
    @total_recovery = Graph.closeout_amount_by_year(current_user,"total_recovery")
    @total_gross_fee_received = Graph.closeout_amount_by_year(current_user,"total_gross_fee_received")
    @total_out_of_pocket_expenses =  Graph.closeout_amount_by_year(current_user,"total_out_of_pocket_expenses").map { |i| i *- 1}
    @referring_fees_paid = Graph.closeout_amount_by_year(current_user,"referring_fees_paid").map {|i| i * -1}
    @total_fee_received = Graph.closeout_amount_by_year(current_user,"total_fee_received")
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
      current_user.lawfirm.cases.where(open: true, practice_group: lf_pg).each do |ca|
        ca.timing.first ? conclusion_date = ca.timing.last.estimated_conclusion_expected : next
        if ca.fee.order(:created_at).last
          if current_date.year == conclusion_date.year
            rev_est_year1 += ca.fee.last.medium_estimate
          elsif current_date.year+1 == conclusion_date.year
            rev_est_year2 += ca.fee.last.medium_estimate
          elsif current_date.year+2 == conclusion_date.year
            rev_est_year3 += ca.fee.last.medium_estimate
          elsif current_date.year+3 == conclusion_date.year
            rev_est_year4 += ca.fee.last.medium_estimate
          elsif current_date.year+4 >= conclusion_date.year
            rev_est_year5_plus += ca.fee.last.medium_estimate
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
      current_user.lawfirm.cases.where(open: true, practice_group: lf_pg).each do |ca|
        ca.timing.first ? conclusion_date = ca.timing.last.estimated_conclusion_expected : next
        if ca.fee.first
          if current_date.year == conclusion_date.year
            rev_est_year1 += ca.fee.last.high_estimate
          elsif current_date.year+1 == conclusion_date.year
            rev_est_year2 += ca.fee.last.high_estimate
          elsif current_date.year+2 == conclusion_date.year
            rev_est_year3 += ca.fee.last.high_estimate
          elsif current_date.year+3 == conclusion_date.year
            rev_est_year4 += ca.fee.last.high_estimate
          elsif current_date.year+4 >= conclusion_date.year
            rev_est_year5_plus += ca.fee.last.high_estimate
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
      current_user.lawfirm.cases.where(open: true, practice_group: lf_pg).each do |ca|
        ca.timing.first ? conclusion_date = ca.timing.last.estimated_conclusion_expected : next
        if ca.fee.last
          if current_date.year == conclusion_date.year
            rev_est_year1 += ca.fee.last.low_estimate
          elsif current_date.year+1 == conclusion_date.year
            rev_est_year2 += ca.fee.last.low_estimate
          elsif current_date.year+2 == conclusion_date.year
            rev_est_year3 += ca.fee.last.low_estimate
          elsif current_date.year+3 == conclusion_date.year
            rev_est_year4 += ca.fee.last.low_estimate
          elsif current_date.year+4 >= conclusion_date.year
            rev_est_year5_plus += ca.fee.last.low_estimate
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

#-----------------Rev by PG at Accelerated Recovery---------------------#
  def rev_by_year_by_pg_accelerated
    lawfirm_pgs = Graph.user_practice_groups(current_user)
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    final_tally =[]
    lawfirm_pgs.each do |lf_pg|
      rev_est_year1 = 0
      rev_est_year2 = 0
      rev_est_year3 = 0
      rev_est_year4 = 0
      rev_est_year5 = 0
      current_user.lawfirm.cases.where(open: true, practice_group: lf_pg).each do |ca|
        ca.timing.first ? conclusion_date = ca.timing.last.estimated_conclusion_fast : next
        if ca.fee.order(:created_at).last
          if current_date.year == conclusion_date.year
            rev_est_year1 += ca.fee.last.medium_estimate
          elsif current_date.year+1 == conclusion_date.year
            rev_est_year2 += ca.fee.last.medium_estimate
          elsif current_date.year+2 == conclusion_date.year
            rev_est_year3 += ca.fee.last.medium_estimate
          elsif current_date.year+3 == conclusion_date.year
            rev_est_year4 += ca.fee.last.medium_estimate
          elsif current_date.year+4 >= conclusion_date.year
            rev_est_year5_plus += ca.fee.last.medium_estimate
          end
        else
          next
        end
        @five_year_rev = [rev_est_year1, rev_est_year2, rev_est_year3, rev_est_year4, rev_est_year5_plus]
      end
      final_tally.push(@five_year_rev)
    end
    final_tally
    zipped_file = lawfirm_pgs.zip(final_tally)
    @hash_file_accelerated = zipped_file.map {|name,values| {'name' => name, 'data'  => values } }.to_json
  end

  def rev_by_year_by_pg_accelerated_low
    lawfirm_pgs = Graph.user_practice_groups(current_user)
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    final_tally =[]
    lawfirm_pgs.each do |lf_pg|
      rev_est_year1 = 0
      rev_est_year2 = 0
      rev_est_year3 = 0
      rev_est_year4 = 0
      rev_est_year5 = 0
      current_user.lawfirm.cases.where(open: true, practice_group: lf_pg).each do |ca|
        ca.timing.first ? conclusion_date = ca.timing.last.estimated_conclusion_fast : next
        if ca.fee.order(:created_at).last
          if current_date.year == conclusion_date.year
            rev_est_year1 += ca.fee.last.low_estimate
          elsif current_date.year+1 == conclusion_date.year
            rev_est_year2 += ca.fee.last.low_estimate
          elsif current_date.year+2 == conclusion_date.year
            rev_est_year3 += ca.fee.last.low_estimate
          elsif current_date.year+3 == conclusion_date.year
            rev_est_year4 += ca.fee.last.low_estimate
          elsif current_date.year+4 >= conclusion_date.year
            rev_est_year5_plus += ca.fee.last.low_estimate
          end
        else
          next
        end
        @five_year_rev = [rev_est_year1, rev_est_year2, rev_est_year3, rev_est_year4, rev_est_year5_plus]
      end
      final_tally.push(@five_year_rev)
    end
    final_tally
    zipped_file = lawfirm_pgs.zip(final_tally)
    @hash_file_accelerated_low = zipped_file.map {|name,values| {'name' => name, 'data'  => values } }.to_json
  end

  def rev_by_year_by_pg_accelerated_high
    lawfirm_pgs = Graph.user_practice_groups(current_user)
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    final_tally =[]
    lawfirm_pgs.each do |lf_pg|
      rev_est_year1 = 0
      rev_est_year2 = 0
      rev_est_year3 = 0
      rev_est_year4 = 0
      rev_est_year5 = 0
      current_user.lawfirm.cases.where(open: true, practice_group: lf_pg).each do |ca|
        ca.timing.first ? conclusion_date = ca.timing.last.estimated_conclusion_fast : next
        if ca.fee.order(:created_at).last
          if current_date.year == conclusion_date.year
            rev_est_year1 += ca.fee.last.high_estimate
          elsif current_date.year+1 == conclusion_date.year
            rev_est_year2 += ca.fee.last.high_estimate
          elsif current_date.year+2 == conclusion_date.year
            rev_est_year3 += ca.fee.last.high_estimate
          elsif current_date.year+3 == conclusion_date.year
            rev_est_year4 += ca.fee.last.high_estimate
          elsif current_date.year+4 >= conclusion_date.year
            rev_est_year5_plus += ca.fee.last.high_estimate
          end
        else
          next
        end
        @five_year_rev = [rev_est_year1, rev_est_year2, rev_est_year3, rev_est_year4, rev_est_year5_plus]
      end
      final_tally.push(@five_year_rev)
    end
    final_tally
    zipped_file = lawfirm_pgs.zip(final_tally)
    @hash_file_accelerated_high = zipped_file.map {|name,values| {'name' => name, 'data'  => values } }.to_json
  end

  def rev_by_year_by_pg_slow_high
    lawfirm_pgs = Graph.user_practice_groups(current_user)
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    final_tally =[]
    lawfirm_pgs.each do |lf_pg|
      rev_est_year1 = 0
      rev_est_year2 = 0
      rev_est_year3 = 0
      rev_est_year4 = 0
      rev_est_year5 = 0
      current_user.lawfirm.cases.where(open: true, practice_group: lf_pg).each do |ca|
        ca.timing.first ? conclusion_date = ca.timing.last.estimated_conclusion_slow : next
        if ca.fee.order(:created_at).last
          if current_date.year == conclusion_date.year
            rev_est_year1 += ca.fee.last.high_estimate
          elsif current_date.year+1 == conclusion_date.year
            rev_est_year2 += ca.fee.last.high_estimate
          elsif current_date.year+2 == conclusion_date.year
            rev_est_year3 += ca.fee.last.high_estimate
          elsif current_date.year+3 == conclusion_date.year
            rev_est_year4 += ca.fee.last.high_estimate
          elsif current_date.year+4 >= conclusion_date.year
            rev_est_year5 += ca.fee.last.high_estimate
          end
        else
          next
        end
        @five_year_rev = [rev_est_year1, rev_est_year2, rev_est_year3, rev_est_year4, rev_est_year5]
      end
      final_tally.push(@five_year_rev)
    end
    final_tally
    zipped_file = lawfirm_pgs.zip(final_tally)
    @hash_file_slow_high = zipped_file.map {|name,values| {'name' => name, 'data'  => values } }.to_json
  end

  def rev_by_year_by_pg_slow_low
    lawfirm_pgs = Graph.user_practice_groups(current_user)
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    final_tally =[]
    lawfirm_pgs.each do |lf_pg|
      rev_est_year1 = 0
      rev_est_year2 = 0
      rev_est_year3 = 0
      rev_est_year4 = 0
      rev_est_year5 = 0
      current_user.lawfirm.cases.where(open: true, practice_group: lf_pg).each do |ca|
        ca.timing.first ? conclusion_date = ca.timing.last.estimated_conclusion_slow : next
        if ca.fee.order(:created_at).last
          if current_date.year == conclusion_date.year
            rev_est_year1 += ca.fee.last.low_estimate
          elsif current_date.year+1 == conclusion_date.year
            rev_est_year2 += ca.fee.last.low_estimate
          elsif current_date.year+2 == conclusion_date.year
            rev_est_year3 += ca.fee.last.low_estimate
          elsif current_date.year+3 == conclusion_date.year
            rev_est_year4 += ca.fee.last.low_estimate
          elsif current_date.year+4 >= conclusion_date.year
            rev_est_year5 += ca.fee.last.low_estimate
          end
        else
          next
        end
        @five_year_rev = [rev_est_year1, rev_est_year2, rev_est_year3, rev_est_year4, rev_est_year5]
      end
      final_tally.push(@five_year_rev)
    end
    final_tally
    zipped_file = lawfirm_pgs.zip(final_tally)
    @hash_file_slow_low = zipped_file.map {|name,values| {'name' => name, 'data'  => values } }.to_json
  end

  def rev_by_year_by_pg_slow
    lawfirm_pgs = Graph.user_practice_groups(current_user)
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    final_tally =[]
    lawfirm_pgs.each do |lf_pg|
      rev_est_year1 = 0
      rev_est_year2 = 0
      rev_est_year3 = 0
      rev_est_year4 = 0
      rev_est_year5 = 0
      current_user.lawfirm.cases.where(open: true, practice_group: lf_pg).each do |ca|
        ca.timing.first ? conclusion_date = ca.timing.last.estimated_conclusion_slow : next
        if ca.fee.order(:created_at).last
          if current_date.year == conclusion_date.year
            rev_est_year1 += ca.fee.last.medium_estimate
          elsif current_date.year+1 == conclusion_date.year
            rev_est_year2 += ca.fee.last.medium_estimate
          elsif current_date.year+2 == conclusion_date.year
            rev_est_year3 += ca.fee.last.medium_estimate
          elsif current_date.year+3 == conclusion_date.year
            rev_est_year4 += ca.fee.last.medium_estimate
          elsif current_date.year+4 >= conclusion_date.year
            rev_est_year5 += ca.fee.last.medium_estimate
          end
        else
          next
        end
        @five_year_rev = [rev_est_year1, rev_est_year2, rev_est_year3, rev_est_year4, rev_est_year5]
      end
      final_tally.push(@five_year_rev)
    end
    final_tally
    zipped_file = lawfirm_pgs.zip(final_tally)
    @hash_file_slow = zipped_file.map {|name,values| {'name' => name, 'data'  => values } }.to_json
  end

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



