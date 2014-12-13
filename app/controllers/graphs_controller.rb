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



