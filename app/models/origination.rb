class Origination < ActiveRecord::Base
  belongs_to :case
  belongs_to :lawfirm

  #validates :case_id, presence: true

  REFERRALS = ['Attorney','Client','Internet','Advertising','Reputation']

  def self.all_referral_sources(user)
    user.lawfirm.originations.collect(&:referral_source).uniq.append(Origination::REFERRALS)
  end

end
