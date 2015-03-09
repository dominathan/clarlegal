class AddHighMedLowReferralToFees < ActiveRecord::Migration
  def change
    add_column    :fees, :high_referral, :integer
    add_column    :fees, :medium_referral, :integer
    add_column    :fees, :low_referral, :integer
    rename_column :fees, :referral, :referral_percentage
  end
end
