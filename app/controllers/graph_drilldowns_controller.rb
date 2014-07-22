class GraphDrilldownsController < ApplicationController
  before_action :signed_in_user
  before_action :belongs_to_firm

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
    cost_by_year('expected','cost')
    yearly_collection(@cost_by_year)
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
  end


  def revenue_collection_by_year(collection_rate,collection_amount)
    set_yearly_rev
    current_user.lawfirm.cases.each do |ca|
      conclusion_date = @current_date.to_time.advance(:months => (time_to_collection(ca,collection_rate)))
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
    current_user.lawfirm.cases.each do |ca|
      conclusion_date = @current_date.to_time.advance(:months => (time_to_collection(ca,collection_rate)))
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
    end
  end


  def revenue_collection_by_month(year_addition,collection_rate,collection_amount)
  #collection_rate = [fast,expected,slow]-- year=(0..4)--collection_amount=[high,collection_amount,low]
    set_monthly_rev
    current_user.lawfirm.cases.each do |ca|
      conclusion_date = @current_date.to_time.advance(:months => (time_to_collection(ca,collection_rate)))
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
    if speed == 'fast'
      case_name.timing.order(:created_at).last.estimated_conclusion_fast
    elsif speed == 'expected'
      case_name.timing.order(:created_at).last.estimated_conclusion_expected
    elsif speed == 'slow'
      case_name.timing.order(:created_at).last.estimated_conclusion_slow
    end
  end

  def collection_expectation(case_name,amount)
    if amount == 'high'
      case_name.fee.order(:created_at).last.high_estimate
    elsif amount == 'medium'
      case_name.fee.order(:created_at).last.medium_estimate
    elsif amount == 'low'
      case_name.fee.order(:created_at).last.low_estimate
    elsif amount == 'cost'
      case_name.fee.order(:created_at).last.cost_estimate
    end
  end

  def all_year_variables
    @rev_by_year_high = []
    @rev_by_year_medium = []
    @rev_by_year_low = []
    @cost_by_year = []
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



end