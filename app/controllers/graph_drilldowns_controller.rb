class GraphDrilldownsController < ApplicationController
  before_action :signed_in_user, :belongs_to_firm, :has_open_cases

  def rev_by_fee_type
    set_category_years
    @hourly_rev = []
    @contingency_rev = []
    @fixed_fee_rev = []
    @mixed_rev = []
    rev_fee_per_year('Fixed Fee', 'expected', 'medium')
    yearly_collection(@fixed_fee_rev)
    rev_fee_per_year('Hourly','expected','medium')
    yearly_collection(@hourly_rev)
    rev_fee_per_year('Contingency','expected','medium')
    yearly_collection(@contingency_rev)
    rev_fee_per_year('Mixed', 'expected', 'medium')
    yearly_collection(@mixed_rev)
    rev_by_fee_type_low
    rev_by_fee_type_high
  end

  def rev_by_fee_type_low
    set_category_years
    @hourly_rev_low = []
    @contingency_rev_low = []
    @fixed_fee_rev_low = []
    @mixed_rev_low = []
    rev_fee_per_year('Fixed Fee', 'expected', 'low')
    yearly_collection(@fixed_fee_rev_low)
    rev_fee_per_year('Hourly','expected','low')
    yearly_collection(@hourly_rev_low)
    rev_fee_per_year('Contingency','expected','low')
    yearly_collection(@contingency_rev_low)
    rev_fee_per_year('Mixed', 'expected', 'low')
    yearly_collection(@mixed_rev_low)
  end

  def rev_by_fee_type_high
    set_category_years
    @hourly_rev_high = []
    @contingency_rev_high = []
    @fixed_fee_rev_high = []
    @mixed_rev_high = []
    rev_fee_per_year('Fixed Fee', 'expected', 'high')
    yearly_collection(@fixed_fee_rev_high)
    rev_fee_per_year('Hourly','expected','high')
    yearly_collection(@hourly_rev_high)
    rev_fee_per_year('Contingency','expected','high')
    yearly_collection(@contingency_rev_high)
    rev_fee_per_year('Mixed', 'expected', 'high')
    yearly_collection(@mixed_rev_high)
  end


  def rev_fee_per_year(fee_structure, collection_rate,collection_amount)
    set_yearly_rev
    open_cases = Graph.open_cases(current_user)
    open_cases.each do |ca|
      conclusion_date = time_to_collection(ca,collection_rate)
      if ca.fee.first
        if ca.fee.order(:created_at).last.fee_type == fee_structure
          if @current_date.year == conclusion_date.year
            @rev_est_year1 += collection_expectation(ca,collection_amount)
          elsif @current_date.year+1 == conclusion_date.year
            @rev_est_year2 += collection_expectation(ca,collection_amount)
          elsif @current_date.year+2 == conclusion_date.year
            @rev_est_year3 += collection_expectation(ca,collection_amount)
          elsif @current_date.year+3 == conclusion_date.year
            @rev_est_year4 += collection_expectation(ca,collection_amount)
          elsif @current_date.year+4 >= conclusion_date.year
            @rev_est_year5_plus += collection_expectation(ca,collection_amount)
          end
        end
      else
        next
      end
    end
  end


  #---------------------BEGIN expected revenue by year and month --------------------

  def revenue_collection_by_year(collection_rate,collection_amount)
    set_yearly_rev
    open_cases = current_user.lawfirm.cases.where(open: true).includes(:fees,:timings)
    open_cases.each do |ca|
      conclusion_date = time_to_collection(ca,collection_rate)
      if @current_date.year == conclusion_date.year
        @rev_est_year1 += collection_expectation(ca,collection_amount)
      elsif @current_date.year+1 == conclusion_date.year
        @rev_est_year2 += collection_expectation(ca,collection_amount)
      elsif @current_date.year+2 == conclusion_date.year
        @rev_est_year3 += collection_expectation(ca,collection_amount)
      elsif @current_date.year+3 == conclusion_date.year
        @rev_est_year4 += collection_expectation(ca,collection_amount)
      elsif @current_date.year+4 >= conclusion_date.year
        @rev_est_year5_plus += collection_expectation(ca,collection_amount)
      end
    end
  end

  def cost_by_year(collection_rate,collection_amount)
    #change the -= to += for above the line grid, also works for line graph if positive
    set_yearly_rev
    open_cases = current_user.lawfirm.cases.where(open: true).includes(:fees,:timings)
    open_cases.each do |ca|
      conclusion_date = time_to_collection(ca,collection_rate)
      if ca.fee.last
        if ca.fee.last.cost_estimate != nil
          if @current_date.year == conclusion_date.year
            @rev_est_year1 -= collection_expectation(ca,collection_amount)
          elsif @current_date.year+1 == conclusion_date.year
            @rev_est_year2 -= collection_expectation(ca,collection_amount)
          elsif @current_date.year+2 == conclusion_date.year
            @rev_est_year3 -= collection_expectation(ca,collection_amount)
          elsif @current_date.year+3 == conclusion_date.year
            @rev_est_year4 -= collection_expectation(ca,collection_amount)
          elsif @current_date.year+4 >= conclusion_date.year
            @rev_est_year5_plus -= collection_expectation(ca,collection_amount)
          end
        else
          next
        end
      end
    end
  end

  def referral_by_year(collection_rate, collection_amount)
    set_yearly_rev
    open_cases = current_user.lawfirm.cases.where(open: true).includes(:fees,:timings)
    open_cases.each do |ca|
      conclusion_date = time_to_collection(ca,collection_rate)
      if ca.fee.last
        if ca.fee.last.referral
          if @current_date.year == conclusion_date.year
            @rev_est_year1 -= collection_expectation(ca,collection_amount)
          elsif @current_date.year+1 == conclusion_date.year
            @rev_est_year2 -= collection_expectation(ca,collection_amount)
          elsif @current_date.year+2 == conclusion_date.year
            @rev_est_year3 -= collection_expectation(ca,collection_amount)
          elsif @current_date.year+3 == conclusion_date.year
            @rev_est_year4 -= collection_expectation(ca,collection_amount)
          elsif @current_date.year+4 >= conclusion_date.year
            @rev_est_year5_plus -= collection_expectation(ca,collection_amount)
          end
        else
          next
        end
      end
    end
  end

  def revenue_collection_by_month(year_addition,collection_rate,collection_amount)
  #collection_rate = [fast,expected,slow]-- year=(0..4)--collection_amount=[high,collection_amount,low]
    set_monthly_rev
    current_user.lawfirm.cases.where(open: true).each do |ca|
      conclusion_date = time_to_collection(ca,collection_rate)
      if @current_date.year+year_addition == conclusion_date.year
        if conclusion_date.month == 1
          @rev_jan += collection_expectation(ca,collection_amount)
        elsif conclusion_date.month == 2
          @rev_feb += collection_expectation(ca,collection_amount)
        elsif conclusion_date.month == 3
          @rev_mar += collection_expectation(ca,collection_amount)
        elsif conclusion_date.month == 4
          @rev_apr += collection_expectation(ca,collection_amount)
        elsif conclusion_date.month == 5
          @rev_may += collection_expectation(ca,collection_amount)
        elsif conclusion_date.month == 6
          @rev_jun += collection_expectation(ca,collection_amount)
        elsif conclusion_date.month == 7
          @rev_jul += collection_expectation(ca,collection_amount)
        elsif conclusion_date.month == 8
          @rev_aug += collection_expectation(ca,collection_amount)
        elsif conclusion_date.month == 9
          @rev_sept += collection_expectation(ca,collection_amount)
        elsif conclusion_date.month == 10
          @rev_oct += collection_expectation(ca,collection_amount)
        elsif conclusion_date.month == 11
          @rev_nov += collection_expectation(ca,collection_amount)
        elsif conclusion_date.month == 12
          @rev_dec += collection_expectation(ca,collection_amount)
        end
      end
    end
  end

  def time_to_collection(case_name,speed)
    if case_name.timing.last
      if speed == 'fast'
        case_name.timing.order(:created_at).last.estimated_conclusion_fast
      elsif speed == 'expected'
        case_name.timing.order(:created_at).last.estimated_conclusion_expected
      elsif speed == 'slow'
        case_name.timing.order(:created_at).last.estimated_conclusion_slow
      end
    end
  end

  def collection_expectation(case_name,amount)
    if case_name.fee.last
      if amount == 'high'
        case_name.fee.order(:created_at).last.high_estimate
      elsif amount == 'medium'
        case_name.fee.order(:created_at).last.medium_estimate
      elsif amount == 'low'
        case_name.fee.order(:created_at).last.low_estimate
      elsif amount == 'cost'
        case_name.fee.order(:created_at).last.cost_estimate
      elsif amount == 'referral'
        case_name.fee.order(:created_at).last.referral
      end
    else
      return 0
    end
  end

  def all_year_variables
    @rev_by_year_high = []
    @rev_by_year_medium = []
    @rev_by_year_low = []
    @cost_by_year = []
    @referral_by_year = []
  end

  def monthly_collection(bucket)
    bucket.push(@rev_jan, @rev_feb, @rev_mar, @rev_apr, @rev_may, @rev_jun, @rev_jul, @rev_aug, @rev_sept, @rev_oct, @rev_nov, @rev_dec)
  end

  def yearly_collection(bucket)
    bucket.push(@rev_est_year1, @rev_est_year2, @rev_est_year3, @rev_est_year4, @rev_est_year5_plus)
  end

  def set_monthly_rev
    @rev_jan=0
    @rev_feb=0
    @rev_mar=0
    @rev_apr=0
    @rev_may=0
    @rev_jun=0
    @rev_jul=0
    @rev_aug=0
    @rev_sept=0
    @rev_oct=0
    @rev_nov=0
    @rev_dec=0
  end

  def set_yearly_rev
    @rev_est_year1 = 0
    @rev_est_year2 = 0
    @rev_est_year3 = 0
    @rev_est_year4 = 0
    @rev_est_year5_plus = 0
  end

  def set_category_years
    @current_date = DateTime.now
    @category_years = [@current_date.year, @current_date.year+1, @current_date.year+2,
                      @current_date.year+3, @current_date.year+4]
  end

  def set_category_months
    @current_date = DateTime.now
    @category_months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sept','Oct','Nov','Dec']
  end

  def years_broken_out_by_months
    @year_1_by_month_low = []
    @year_1_by_month_medium = []
    @year_1_by_month_high = []
    @year_2_by_month_low = []
    @year_2_by_month_medium = []
    @year_2_by_month_high = []
    @year_3_by_month_low = []
    @year_3_by_month_medium = []
    @year_3_by_month_high = []
    @year_4_by_month_low = []
    @year_4_by_month_medium = []
    @year_4_by_month_high = []
    @year_5_by_month_low = []
    @year_5_by_month_medium = []
    @year_5_by_month_high = []
  end

  def rev_by_year_expected
    set_category_years
    all_year_variables
    revenue_collection_by_year('expected','high')
    yearly_collection(@rev_by_year_high)
    revenue_collection_by_year('expected','medium')
    yearly_collection(@rev_by_year_medium)
    revenue_collection_by_year('expected','low')
    yearly_collection(@rev_by_year_low)
    cost_by_year('expected','cost')
    yearly_collection(@cost_by_year)
    referral_by_year('expected','referral')
    yearly_collection(@referral_by_year)
    @rev_by_year_high = Graph.add_arrays(@rev_by_year_high, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @rev_by_year_medium = Graph.add_arrays(@rev_by_year_medium, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @rev_by_year_low = Graph.add_arrays(@rev_by_year_low, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @overhead_by_year = Array.new(@rev_by_year_low.length, Graph.expected_overhead_next_year(current_user)).map { |x| x*-1 }
  end

  def rev_by_year_slow
    set_category_years
    all_year_variables
    revenue_collection_by_year('slow','high')
    yearly_collection(@rev_by_year_high)
    revenue_collection_by_year('slow','medium')
    yearly_collection(@rev_by_year_medium)
    revenue_collection_by_year('slow','low')
    yearly_collection(@rev_by_year_low)
    cost_by_year('slow','cost')
    yearly_collection(@cost_by_year)
    referral_by_year('slow','referral')
    yearly_collection(@referral_by_year)
    @rev_by_year_high = Graph.add_arrays(@rev_by_year_high, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @rev_by_year_medium = Graph.add_arrays(@rev_by_year_medium, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @rev_by_year_low = Graph.add_arrays(@rev_by_year_low, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @overhead_by_year = Array.new(@rev_by_year_low.length, Graph.expected_overhead_next_year(current_user)).map { |x| x*-1 }
  end

  def rev_by_year
    set_category_years
    years_broken_out_by_months
    all_year_variables
    revenue_collection_by_year('fast','high')
    yearly_collection(@rev_by_year_high)
    revenue_collection_by_year('fast','medium')
    yearly_collection(@rev_by_year_medium)
    revenue_collection_by_year('fast','low')
    yearly_collection(@rev_by_year_low)
    cost_by_year('fast','cost')
    yearly_collection(@cost_by_year)
    referral_by_year('fast','referral')
    yearly_collection(@referral_by_year)
    @rev_by_year_high = Graph.add_arrays(@rev_by_year_high, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @rev_by_year_medium = Graph.add_arrays(@rev_by_year_medium, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @rev_by_year_low = Graph.add_arrays(@rev_by_year_low, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @overhead_by_year = Array.new(@rev_by_year_low.length, Graph.expected_overhead_next_year(current_user)).map { |x| x*-1 }
  end

  def rev_year_1_slow
    set_category_months
    set_category_years
    years_broken_out_by_months
    revenue_collection_by_month(0,'slow','high')
    monthly_collection(@year_1_by_month_high)
    revenue_collection_by_month(0,'slow','medium')
    monthly_collection(@year_1_by_month_medium)
    revenue_collection_by_month(0,'slow','low')
    monthly_collection(@year_1_by_month_low)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_1_expected
    set_category_months
    set_category_years
    years_broken_out_by_months
    revenue_collection_by_month(0,'expected','high')
    monthly_collection(@year_1_by_month_high)
    revenue_collection_by_month(0,'expected','medium')
    monthly_collection(@year_1_by_month_medium)
    revenue_collection_by_month(0,'expected','low')
    monthly_collection(@year_1_by_month_low)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_1_accelerated
    set_category_months
    set_category_years
    years_broken_out_by_months
    revenue_collection_by_month(0,'fast','high')
    monthly_collection(@year_1_by_month_high)
    revenue_collection_by_month(0,'fast','medium')
    monthly_collection(@year_1_by_month_medium)
    revenue_collection_by_month(0,'fast','low')
    monthly_collection(@year_1_by_month_low)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_2_slow
    set_category_months
    set_category_years
    years_broken_out_by_months
    revenue_collection_by_month(1,'slow','high')
    monthly_collection(@year_2_by_month_high)
    revenue_collection_by_month(1,'slow','medium')
    monthly_collection(@year_2_by_month_medium)
    revenue_collection_by_month(1,'slow','low')
    monthly_collection(@year_2_by_month_low)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_2_expected
    set_category_months
    set_category_years
    years_broken_out_by_months
    revenue_collection_by_month(1,'expected','high')
    monthly_collection(@year_2_by_month_high)
    revenue_collection_by_month(1,'expected','medium')
    monthly_collection(@year_2_by_month_medium)
    revenue_collection_by_month(1,'expected','low')
    monthly_collection(@year_2_by_month_low)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_2_accelerated
    set_category_months
    set_category_years
    years_broken_out_by_months
    revenue_collection_by_month(1,'fast','high')
    monthly_collection(@year_2_by_month_high)
    revenue_collection_by_month(1,'fast','medium')
    monthly_collection(@year_2_by_month_medium)
    revenue_collection_by_month(1,'fast','low')
    monthly_collection(@year_2_by_month_low)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_3_slow
    set_category_months
    set_category_years
    years_broken_out_by_months
    revenue_collection_by_month(2,'slow','high')
    monthly_collection(@year_3_by_month_high)
    revenue_collection_by_month(2,'slow','medium')
    monthly_collection(@year_3_by_month_medium)
    revenue_collection_by_month(2,'slow','low')
    monthly_collection(@year_3_by_month_low)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_3_expected
    set_category_months
    set_category_years
    years_broken_out_by_months
    revenue_collection_by_month(2,'expected','high')
    monthly_collection(@year_3_by_month_high)
    revenue_collection_by_month(2,'expected','medium')
    monthly_collection(@year_3_by_month_medium)
    revenue_collection_by_month(2,'expected','low')
    monthly_collection(@year_3_by_month_low)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_3_accelerated
    set_category_months
    set_category_years
    years_broken_out_by_months
    revenue_collection_by_month(2,'fast','high')
    monthly_collection(@year_3_by_month_high)
    revenue_collection_by_month(2,'fast','medium')
    monthly_collection(@year_3_by_month_medium)
    revenue_collection_by_month(2,'fast','low')
    monthly_collection(@year_3_by_month_low)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_4_slow
    set_category_months
    set_category_years
    years_broken_out_by_months
    revenue_collection_by_month(3,'slow','high')
    monthly_collection(@year_4_by_month_high)
    revenue_collection_by_month(3,'slow','medium')
    monthly_collection(@year_4_by_month_medium)
    revenue_collection_by_month(3,'slow','low')
    monthly_collection(@year_4_by_month_low)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_4_expected
    set_category_months
    set_category_years
    years_broken_out_by_months
    revenue_collection_by_month(3,'expected','high')
    monthly_collection(@year_4_by_month_high)
    revenue_collection_by_month(3,'expected','medium')
    monthly_collection(@year_4_by_month_medium)
    revenue_collection_by_month(3,'expected','low')
    monthly_collection(@year_4_by_month_low)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_4_accelerated
    set_category_months
    set_category_years
    years_broken_out_by_months
    revenue_collection_by_month(3,'fast','high')
    monthly_collection(@year_4_by_month_high)
    revenue_collection_by_month(3,'fast','medium')
    monthly_collection(@year_4_by_month_medium)
    revenue_collection_by_month(3,'fast','low')
    monthly_collection(@year_4_by_month_low)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_5_slow
    set_category_months
    set_category_years
    years_broken_out_by_months
    revenue_collection_by_month(4,'slow','high')
    monthly_collection(@year_5_by_month_high)
    revenue_collection_by_month(4,'slow','medium')
    monthly_collection(@year_5_by_month_medium)
    revenue_collection_by_month(4,'slow','low')
    monthly_collection(@year_5_by_month_low)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_5_expected
    set_category_months
    set_category_years
    years_broken_out_by_months
    revenue_collection_by_month(4,'expected','high')
    monthly_collection(@year_5_by_month_high)
    revenue_collection_by_month(4,'expected','medium')
    monthly_collection(@year_5_by_month_medium)
    revenue_collection_by_month(4,'expected','low')
    monthly_collection(@year_5_by_month_low)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_5_accelerated
    set_category_months
    set_category_years
    years_broken_out_by_months
    revenue_collection_by_month(4,'fast','high')
    monthly_collection(@year_5_by_month_high)
    revenue_collection_by_month(4,'fast','medium')
    monthly_collection(@year_5_by_month_medium)
    revenue_collection_by_month(4,'fast','low')
    monthly_collection(@year_5_by_month_low)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

end
