class Origination < ActiveRecord::Base
  belongs_to :case
  belongs_to :lawfirm

  attr_accessor :new_referral_source
  #validates :case_id, presence: true

  REFERRALS = ['Attorney','Client','Internet','Advertising','Reputation']

  def self.all_referral_sources(user)
    user_added_referrals =  user.lawfirm.originations.collect(&:referral_source).uniq
    original_referrals = Origination::REFERRALS
    user_added_referrals.concat(original_referrals).sort.uniq
  end

end
