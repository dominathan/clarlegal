class Origination < ActiveRecord::Base
  belongs_to :case
  belongs_to :lawfirm

  attr_accessor :new_referral_source
  #validates :case_id, presence: true

  REFERRALS = ['Attorney','Client','Internet','Advertising','Reputation']

  def self.all_referral_sources(user)
    user.lawfirm.originations.collect(&:referral_source).uniq.sort.append(Origination::REFERRALS)
  end

end
