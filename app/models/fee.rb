class Fee < ActiveRecord::Base
  belongs_to :case

  #validates :case_id, presence: true
  validates :high_estimate, presence: true
  validates :medium_estimate, presence: true
  validates :low_estimate, presence: true


  FEE_PAYMENT_LIKELIHOOD = ['High','Medium','Low']
  FEE_TYPE = ['Hourly', 'Fixed Fee', "Mixed", 'Contingency']

  def self.get_fee_dates(user_case)
    updates = []
    for date in user_case.fee.order(:created_at)
      updates << date.updated_at.strftime("%b %d, %Y")
    end
    updates
  end

  def self.get_fee_high_estimate(user_case)
    high = []
    for amt in user_case.fee.order(:created_at)
      high << amt.high_estimate
    end
    high
  end

  def self.get_fee_medium_estimate(user_case)
    medium = []
    for amt in user_case.fee.order(:created_at)
      medium << amt.medium_estimate
    end
    medium
  end

  def self.get_fee_low_estimate(user_case)
    low = []
    for amt in user_case.fee.order(:created_at)
      low << amt.low_estimate
    end
    low
  end

  #Move expected revenue to actual revenue on a monthly basis for cases that are fixed fee or hourly
  def self.fixed_and_hourly_estimates_to_actual
    current_date = Date.today
    Case.all.each do |ca|
      if ca.fees.last.fee_type == "Fixed Fee"
        fast_months_remaining = ((ca.timings.last.estimated_conclusion_fast - current_date).to_f / (365/12).to_f).round
        expected_months_remaining = ((ca.timings.last.estimated_conclusion_expected - current_date).to_f / (365/12).to_f).round
        slow_months_remaining = ((ca.timings.last.estimated_conclusion_slow - current_date).to_f / (365/12).to_f).round
        move_expected_to_actual_fast = ca.fees.last.medium_estimate / fast_months_remaining
        move_expected_to_actual_expected = ca.fees.last.medium_estimate / expected_months_remaining
        move_expected_to_actual_slow = ca.fees.last.medium_estimate / slow_months_remaining
      end
    end
  end

end
