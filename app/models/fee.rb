class Fee < ActiveRecord::Base
  belongs_to :case

  validates :case_id, presence: true


  FEE_PAYMENT_LIKELIHOOD = ['High','Medium','Low']
  FEE_TYPE = ['Hourly', 'Fixed Fee', 'Contingency']
end
