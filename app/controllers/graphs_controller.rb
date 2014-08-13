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
    closed_cases = Graph.closed_cases(current_user)
    category_years = Graph.closeout_years
    current_date = DateTime.now
    @final_tally = []
    rev_est_year1 = 0
    rev_est_year2 = 0
    rev_est_year3 = 0
    rev_est_year4 = 0
    rev_est_year5_plus = 0
    closed_cases.each do |ca|
      ca.closeouts.last.date_fee_received ?
        date_received = ca.closeouts.last.date_fee_received.year : next
      if ca.closeouts.last.total_recovery
        if date_received == category_years[0]
          rev_est_year1 += ca.closeouts.last.total_recovery
        elsif date_received == category_years[1]
          rev_est_year2 += ca.closeouts.last.total_recovery
        elsif date_received == category_years[2]
          rev_est_year3 += ca.closeouts.last.total_recovery
        elsif date_received == category_years[3]
          rev_est_year4 += ca.closeouts.last.total_recovery
        elsif date_received == category_years[4]
          rev_est_year5_plus += ca.closeouts.last.total_recovery
        else
          next
        end
      end
    end
    @final_tally = [rev_est_year1,rev_est_year2,rev_est_year3,rev_est_year4,rev_est_year5_plus]
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
end



