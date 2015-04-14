class Fee < ActiveRecord::Base
  belongs_to :case

  validates :high_estimate, :medium_estimate, :low_estimate, presence: true,
                                                            numericality: { only_integer: true}
  validates :referral_percentage, presence: true

  def referral_estimates
    self.medium_referral = (self.referral_percentage * self.medium_estimate).round(0)
    self.high_referral = (self.referral_percentage * self.high_estimate).round(0)
    self.low_referral = (self.referral_percentage * self.low_estimate).round(0)
  end

  def self.get_fee_dates(user_case)
    updates = []
    for date in user_case.fee.order(:created_at)
      updates << date.created_at.strftime("%b %d, %Y")
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
