class AddNewReferralSourceToOrigination < ActiveRecord::Migration
  def change
    add_column :originations, :new_referral_source, :string
  end
end
