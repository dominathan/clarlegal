class Origination < ActiveRecord::Base
  belongs_to :case

  #validates :case_id, presence: true

  REFERRALS = ['Attorney','Client','Internet','Advertising','Reputation']

end
