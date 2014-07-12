class Fee < ActiveRecord::Base
  belongs_to :case

  validates :case_id, presence: true
  validates :high_estimate, presence: true
  validates :medium_estimate, presence: true
  validates :low_estimate, presence: true


  FEE_PAYMENT_LIKELIHOOD = ['High','Medium','Low']
  FEE_TYPE = ['Hourly', 'Fixed Fee', 'Contingency']
end
