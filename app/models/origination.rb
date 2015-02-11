class Origination < ActiveRecord::Base
  belongs_to :case
  belongs_to :lawfirm, inverse_of: :originations

  # validate :referral_source_cannot_be_taken_by_lawfirm
  #validates :referral_source, uniqueness: {scope: :case_id, through: :lawfirm_id, case_sensitive: false}

  attr_accessor :new_referral_source

  REFERRALS = ['Attorney','Client','Internet','Advertising','Reputation']

  # def referral_source_cannot_be_taken_by_lawfirm
  #   binding.pry
  # => self.case does not work be case_id has not been created.  Also, cannot find by current_user
  #   case_list = self.case.lawfirm.cases.id
  #   binding.pry
  #   ref_sources = Origination.where(id: case_list).map { |orig| orig.referral_source.downcase }
  #   if ref_sources.includes?(referral_source.downcase)
  #     errors.add(:referral_source, "Referral Source is already taken.  Please select it form the drop down menu")
  #   end
  # end

  def self.all_referral_sources(user)
    user_added_referrals =  user.lawfirm.originations.collect(&:referral_source).uniq - ["",nil]
    original_referrals = Origination::REFERRALS
    user_added_referrals.concat(original_referrals).sort.uniq
  end

end
