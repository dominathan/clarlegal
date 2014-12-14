class GraphDrilldownsController < ApplicationController
  before_action :signed_in_user, :belongs_to_firm, :has_open_cases

  #---------------------BEGIN expected revenue by year and month --------------------

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

  def set_category_months
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
    rev_by_year_high = Graph.fee_estimate_by_year(current_user,'estimated_conclusion_expected','high_estimate')
    rev_by_year_medium = Graph.fee_estimate_by_year(current_user,'estimated_conclusion_expected','medium_estimate')
    rev_by_year_low = Graph.fee_estimate_by_year(current_user,'estimated_conclusion_expected','low_estimate')
    @cost_by_year = Graph.fee_estimate_by_year(current_user,'estimated_conclusion_expected','cost_estimate').map { |x| x*-1}
    @referral_by_year = Graph.fee_estimate_by_year(current_user,'estimated_conclusion_expected','referral').map { |x| x*-1}
    @category_years = Graph.expected_year_only
    @rev_by_year_high = Graph.add_arrays(rev_by_year_high, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @rev_by_year_medium = Graph.add_arrays(rev_by_year_medium, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @rev_by_year_low = Graph.add_arrays(rev_by_year_low, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @overhead_by_year = Array.new(@rev_by_year_low.length, Graph.expected_overhead_next_year(current_user)).map { |x| x*-1 }
  end

  def rev_by_year_slow
    @category_years = Graph.expected_year_only
    rev_by_year_high = Graph.fee_estimate_by_year(current_user,'estimated_conclusion_slow','high_estimate')
    rev_by_year_medium = Graph.fee_estimate_by_year(current_user,'estimated_conclusion_slow','medium_estimate')
    rev_by_year_low = Graph.fee_estimate_by_year(current_user,'estimated_conclusion_slow','low_estimate')
    @cost_by_year = Graph.fee_estimate_by_year(current_user,'estimated_conclusion_slow','cost_estimate').map { |x| x*-1}
    @referral_by_year = Graph.fee_estimate_by_year(current_user,'estimated_conclusion_slow','referral').map { |x| x*-1}
    @rev_by_year_high = Graph.add_arrays(rev_by_year_high, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @rev_by_year_medium = Graph.add_arrays(rev_by_year_medium, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @rev_by_year_low = Graph.add_arrays(rev_by_year_low, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @overhead_by_year = Array.new(@rev_by_year_low.length, Graph.expected_overhead_next_year(current_user)).map { |x| x*-1 }
  end

  def rev_by_year
    @category_years = Graph.expected_year_only
    rev_by_year_high = Graph.fee_estimate_by_year(current_user,'estimated_conclusion_fast','high_estimate')
    rev_by_year_medium = Graph.fee_estimate_by_year(current_user,'estimated_conclusion_fast','medium_estimate')
    rev_by_year_low = Graph.fee_estimate_by_year(current_user,'estimated_conclusion_fast','low_estimate')
    @cost_by_year = Graph.fee_estimate_by_year(current_user,'estimated_conclusion_fast','cost_estimate').map { |x| x*-1}
    @referral_by_year = Graph.fee_estimate_by_year(current_user,'estimated_conclusion_fast','referral').map { |x| x*-1}
    @rev_by_year_high = Graph.add_arrays(rev_by_year_high, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @rev_by_year_medium = Graph.add_arrays(rev_by_year_medium, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @rev_by_year_low = Graph.add_arrays(rev_by_year_low, Graph.add_arrays(@cost_by_year, @referral_by_year))
    @overhead_by_year = Array.new(@rev_by_year_low.length, Graph.expected_overhead_next_year(current_user)).map { |x| x*-1 }
  end

  def rev_year_1_slow
    @category_years = Graph.expected_year_only
    set_category_months
    @year_1_by_month_low = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_slow","low_estimate",0)
    @year_1_by_month_medium = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_slow","medium_estimate",0)
    @year_1_by_month_high = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_slow","high_estimate",0)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_1_expected
    set_category_months
    @category_years = Graph.expected_year_only
    @year_1_by_month_low = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_expected","low_estimate",0)
    @year_1_by_month_medium = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_expected","medium_estimate",0)
    @year_1_by_month_high = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_expected","high_estimate",0)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_1_accelerated
    set_category_months
    @category_years = Graph.expected_year_only
    @year_1_by_month_low = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_fast","low_estimate",0)
    @year_1_by_month_medium = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_fast","medium_estimate",0)
    @year_1_by_month_high = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_fast","high_estimate",0)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_2_slow
    set_category_months
    @category_years = Graph.expected_year_only
    @year_3_by_month_low = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_slow","low_estimate",1)
    @year_2_by_month_medium = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_slow","medium_estimate",1)
    @year_2_by_month_high = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_slow","high_estimate",1)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_2_expected
    set_category_months
    @category_years = Graph.expected_year_only
    @year_2_by_month_low = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_expected","low_estimate",1)
    @year_2_by_month_medium = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_expected","medium_estimate",1)
    @year_2_by_month_high = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_expected","high_estimate",1)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_2_accelerated
    set_category_months
    @category_years = Graph.expected_year_only
    @year_2_by_month_low = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_fast","low_estimate",1)
    @year_2_by_month_medium = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_fast","medium_estimate",1)
    @year_2_by_month_high = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_fast","high_estimate",1)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_3_slow
    set_category_months
    @category_years = Graph.expected_year_only
    @year_3_by_month_low = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_slow","low_estimate",2)
    @year_3_by_month_medium = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_slow","medium_estimate",2)
    @year_3_by_month_high = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_slow","high_estimate",2)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_3_expected
    set_category_months
    @category_years = Graph.expected_year_only
    @year_3_by_month_low = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_expected","low_estimate",2)
    @year_3_by_month_medium = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_expected","medium_estimate",2)
    @year_3_by_month_high = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_expected","high_estimate",2)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_3_accelerated
    set_category_months
    @category_years = Graph.expected_year_only
    @year_3_by_month_low = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_fast","low_estimate",2)
    @year_3_by_month_medium = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_fast","medium_estimate",2)
    @year_3_by_month_high = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_fast","high_estimate",2)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_4_slow
    set_category_months
    @category_years = Graph.expected_year_only
    @year_4_by_month_low = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_slow","low_estimate",3)
    @year_4_by_month_medium = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_slow","medium_estimate",3)
    @year_4_by_month_high = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_slow","high_estimate",3)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_4_expected
    set_category_months
    @category_years = Graph.expected_year_only
    @year_4_by_month_low = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_expected","low_estimate",3)
    @year_4_by_month_medium = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_expected","medium_estimate",3)
    @year_4_by_month_high = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_expected","high_estimate",3)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_4_accelerated
    set_category_months
    @category_years = Graph.expected_year_only
    @year_4_by_month_low = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_fast","low_estimate",3)
    @year_4_by_month_medium = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_fast","medium_estimate",3)
    @year_4_by_month_high = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_fast","high_estimate",3)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_5_slow
    set_category_months
    @category_years = Graph.expected_year_only
    @year_5_by_month_low = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_slow","low_estimate",4)
    @year_5_by_month_medium = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_slow","medium_estimate",4)
    @year_5_by_month_high = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_slow","high_estimate",4)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_5_expected
    set_category_months
    @category_years = Graph.expected_year_only
    @year_5_by_month_low = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_expected","low_estimate",4)
    @year_5_by_month_medium = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_expected","medium_estimate",4)
    @year_5_by_month_high = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_expected","high_estimate",4)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

  def rev_year_5_accelerated
    set_category_months
    @category_years = Graph.expected_year_only
    @year_5_by_month_low = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_fast","low_estimate",4)
    @year_5_by_month_medium = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_fast","medium_estimate",4)
    @year_5_by_month_high = Graph.fee_estimate_by_month(current_user,"estimated_conclusion_fast","high_estimate",4)
    @overhead_by_month = Array.new(12,Graph.overhead_by_month(current_user))
  end

end
