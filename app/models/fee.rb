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
end
