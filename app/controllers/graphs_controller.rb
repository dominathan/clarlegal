class GraphsController < ApplicationController
  before_action :signed_in_user
  before_action :belongs_to_firm

  def practice_group_pie
    #filter by practice_group ... pg
    @case_count_by_pg = []
    @lawfirm_pgs = current_user.lawfirm.practicegroups.collect { |n| n.group_name }
    @pg_count = @lawfirm_pgs.length
    0.upto(@pg_count-1) do |n|
      @case_count_by_pg.push(current_user.lawfirm.cases.where(practice_group: @lawfirm_pgs[n]).count)
    end
    @final_data = @lawfirm_pgs.zip(@case_count_by_pg)
  end

  def practice_group_revenue_pie_low
    @lawfirm_pgs = current_user.lawfirm.practicegroups.collect { |n| n.group_name }
    #need to have one for high, one for medium, one for low
    @total_rev_per_pg_low = []
    @lawfirm_pgs.each do |pg|
      sum_total = 0
      current_user.lawfirm.cases.where(practice_group: pg).each do |ca|
        sum_total += ca.fee.first.low_estimate
      end
      @total_rev_per_pg_low << sum_total
    end
    @final_low_rev = @lawfirm_pgs.zip(@total_rev_per_pg_low)
    practice_group_revenue_pie_medium
    practice_group_revenue_pie_high
  end

  def practice_group_revenue_pie_medium
    @lawfirm_pgs = current_user.lawfirm.practicegroups.collect { |n| n.group_name }
    @total_rev_per_pg_medium = []
    @lawfirm_pgs.each do |pg|
      sum_total = 0
      current_user.lawfirm.cases.where(practice_group: pg).each do |ca|
        sum_total += ca.fee.first.medium_estimate
      end
      @total_rev_per_pg_medium << sum_total
    end
    @final_medium_rev = @lawfirm_pgs.zip(@total_rev_per_pg_medium)
  end

  def practice_group_revenue_pie_high
    @lawfirm_pgs = current_user.lawfirm.practicegroups.collect { |n| n.group_name }
    @total_rev_per_pg_high = []
    @lawfirm_pgs.each do |pg|
      sum_total = 0
      current_user.lawfirm.cases.where(practice_group: pg).each do |ca|
        sum_total += ca.fee.first.high_estimate
      end
      @total_rev_per_pg_high << sum_total
    end
    @final_high_rev = @lawfirm_pgs.zip(@total_rev_per_pg_high)
  end

  def case_revenue_by_year
    #graph for HIGH REVENUE ESTIMATE on MEDIUM EXPECTED COLLECTION DATES
    #this is for expected conclusion date and high revenues
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    rev_est_year1 = 0
    rev_est_year2 = 0
    rev_est_year3 = 0
    rev_est_year4 = 0
    rev_est_year5_plus = 0
    @high_final_estimate = []
    current_user.lawfirm.cases.each do |ca|
      conclusion_date = current_date.to_time.advance(:months => (ca.timing.first.estimated_conclusion_expected))
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
    end
    case_revenue_by_year_low
    case_revenue_by_year_medium
    @high_final_estimate.push(rev_est_year1,rev_est_year2,rev_est_year3,rev_est_year4,rev_est_year5_plus)
  end

  def case_revenue_by_year_medium
    current_date = DateTime.now
    rev_est_year1 = 0
    rev_est_year2 = 0
    rev_est_year3 = 0
    rev_est_year4 = 0
    rev_est_year5_plus = 0
    @medium_final_estimate = []
    current_user.lawfirm.cases.each do |ca|
      conclusion_date = current_date.to_time.advance(:months => (ca.timing.first.estimated_conclusion_expected))
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
    end
    @medium_final_estimate.push(rev_est_year1,rev_est_year2,rev_est_year3,rev_est_year4,rev_est_year5_plus)
  end

    def case_revenue_by_year_low
    current_date = DateTime.now
    rev_est_year1 = 0
    rev_est_year2 = 0
    rev_est_year3 = 0
    rev_est_year4 = 0
    rev_est_year5_plus = 0
    @low_final_estimate = []
    current_user.lawfirm.cases.each do |ca|
      conclusion_date = current_date.to_time.advance(:months => (ca.timing.first.estimated_conclusion_expected))
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
    end
    @low_final_estimate.push(rev_est_year1,rev_est_year2,rev_est_year3,rev_est_year4,rev_est_year5_plus)
  end

  def case_revenue_by_year_fast
    #graph for HIGH REVENUE ESTIMATE on FAST EXPECTED COLLECTION DATES
    #this is for expected conclusion date and high revenues
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    rev_est_year1 = 0
    rev_est_year2 = 0
    rev_est_year3 = 0
    rev_est_year4 = 0
    rev_est_year5_plus = 0
    @high_fast_final_estimate = []
    current_user.lawfirm.cases.each do |ca|
      conclusion_date = current_date.to_time.advance(:months => (ca.timing.first.estimated_conclusion_fast))
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
    end
    case_revenue_by_year_fast_medium
    case_revenue_by_year_fast_low
    @high_fast_final_estimate.push(rev_est_year1,rev_est_year2,rev_est_year3,rev_est_year4,rev_est_year5_plus)
  end

  def case_revenue_by_year_fast_medium
    #graph for MEDIUM REVENUE ESTIMATE on FAST EXPECTED COLLECTION DATES
    #this is for expected conclusion date and high revenues
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    rev_est_year1 = 0
    rev_est_year2 = 0
    rev_est_year3 = 0
    rev_est_year4 = 0
    rev_est_year5_plus = 0
    @medium_fast_final_estimate = []
    current_user.lawfirm.cases.each do |ca|
      conclusion_date = current_date.to_time.advance(:months => (ca.timing.first.estimated_conclusion_fast))
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
    end
    @medium_fast_final_estimate.push(rev_est_year1,rev_est_year2,rev_est_year3,rev_est_year4,rev_est_year5_plus)
  end

  def case_revenue_by_year_fast_low
    #graph for LOW REVENUE ESTIMATE on FAST EXPECTED COLLECTION DATES
    #this is for expected conclusion date and high revenues
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    rev_est_year1 = 0
    rev_est_year2 = 0
    rev_est_year3 = 0
    rev_est_year4 = 0
    rev_est_year5_plus = 0
    @low_fast_final_estimate = []
    current_user.lawfirm.cases.each do |ca|
      conclusion_date = current_date.to_time.advance(:months => (ca.timing.first.estimated_conclusion_fast))
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
    end
    @low_fast_final_estimate.push(rev_est_year1,rev_est_year2,rev_est_year3,rev_est_year4,rev_est_year5_plus)
  end

  def case_revenue_by_year_slow
    #graph for LOW REVENUE ESTIMATE on SLOW EXPECTED COLLECTION DATES
    #this is for expected conclusion date and high revenues
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    rev_est_year1 = 0
    rev_est_year2 = 0
    rev_est_year3 = 0
    rev_est_year4 = 0
    rev_est_year5_plus = 0
    @low_slow_final_estimate = []
    current_user.lawfirm.cases.each do |ca|
      conclusion_date = current_date.to_time.advance(:months => (ca.timing.first.estimated_conclusion_slow))
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
    end
    case_revenue_by_year_slow_medium
    case_revenue_by_year_slow_high
    @low_slow_final_estimate.push(rev_est_year1,rev_est_year2,rev_est_year3,rev_est_year4,rev_est_year5_plus)
  end

    def case_revenue_by_year_slow_medium
    #graph for MEDIUM REVENUE ESTIMATE on SLOW EXPECTED COLLECTION DATES
    #this is for expected conclusion date and high revenues
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    rev_est_year1 = 0
    rev_est_year2 = 0
    rev_est_year3 = 0
    rev_est_year4 = 0
    rev_est_year5_plus = 0
    @medium_slow_final_estimate = []
    current_user.lawfirm.cases.each do |ca|
      conclusion_date = current_date.to_time.advance(:months => (ca.timing.first.estimated_conclusion_slow))
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
    end
    @medium_slow_final_estimate.push(rev_est_year1,rev_est_year2,rev_est_year3,rev_est_year4,rev_est_year5_plus)
  end

    def case_revenue_by_year_slow_high
    #graph for HIGH REVENUE ESTIMATE on SLOW EXPECTED COLLECTION DATES
    #this is for expected conclusion date and high revenues
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    rev_est_year1 = 0
    rev_est_year2 = 0
    rev_est_year3 = 0
    rev_est_year4 = 0
    rev_est_year5_plus = 0
    @high_slow_final_estimate = []
    current_user.lawfirm.cases.each do |ca|
      conclusion_date = current_date.to_time.advance(:months => (ca.timing.first.estimated_conclusion_slow))
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
    end
    @high_slow_final_estimate.push(rev_est_year1,rev_est_year2,rev_est_year3,rev_est_year4,rev_est_year5_plus)
  end

  def list_of_firm_practice_groups
    @lf_pgs = current_user.lawfirm.practicegroups.collect { |n| n.group_name }
  end


  def rev_by_year_by_pg
    list_of_firm_practice_groups
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    @final_tally =[]
    @lf_pgs.each do |lf_pg|
      rev_est_year1 = 0
      rev_est_year2 = 0
      rev_est_year3 = 0
      rev_est_year4 = 0
      rev_est_year5_plus = 0
      current_user.lawfirm.cases.where(practice_group: lf_pg).each do |ca|
        conclusion_date = current_date.to_time.advance(:months => (ca.timing.first.estimated_conclusion_expected))
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
        @five_year_rev = [rev_est_year1, rev_est_year2, rev_est_year3, rev_est_year4, rev_est_year5_plus]
      end
      @final_tally.push(@five_year_rev)
    end
    @final_tally
    zipped_file = @lf_pgs.zip(@final_tally)
    @hash_file = zipped_file.map {|name,values| {'name' => name, 'data'  => values } }.to_json
  end

    def rev_by_year_by_pg_high
    list_of_firm_practice_groups
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    @final_tally =[]
    @lf_pgs.each do |lf_pg|
      rev_est_year1 = 0
      rev_est_year2 = 0
      rev_est_year3 = 0
      rev_est_year4 = 0
      rev_est_year5_plus = 0
      current_user.lawfirm.cases.where(practice_group: lf_pg).each do |ca|
        conclusion_date = current_date.to_time.advance(:months => (ca.timing.first.estimated_conclusion_expected))
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
        @five_year_rev = [rev_est_year1, rev_est_year2, rev_est_year3, rev_est_year4, rev_est_year5_plus]
      end
      @final_tally.push(@five_year_rev)
    end
    @final_tally
    zipped_file = @lf_pgs.zip(@final_tally)
    @hash_file_high = zipped_file.map {|name,values| {'name' => name, 'data'  => values } }.to_json
  end

  def rev_by_year_by_pg_low
    list_of_firm_practice_groups
    current_date = DateTime.now
    @category_years = [current_date.year, current_date.year+1, current_date.year+2,
                      current_date.year+3, current_date.year+4]
    @final_tally =[]
    @lf_pgs.each do |lf_pg|
      rev_est_year1 = 0
      rev_est_year2 = 0
      rev_est_year3 = 0
      rev_est_year4 = 0
      rev_est_year5_plus = 0
      current_user.lawfirm.cases.where(practice_group: lf_pg).each do |ca|
        conclusion_date = current_date.to_time.advance(:months => (ca.timing.first.estimated_conclusion_expected))
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
        @five_year_rev = [rev_est_year1, rev_est_year2, rev_est_year3, rev_est_year4, rev_est_year5_plus]
      end
      @final_tally.push(@five_year_rev)
    end
    @final_tally
    zipped_file = @lf_pgs.zip(@final_tally)
    @hash_file_low = zipped_file.map {|name,values| {'name' => name, 'data'  => values } }.to_json
  end
end

