class AddFeetoReferralSourcetoFee < ActiveRecord::Migration
  def change
    add_column :fees, :referral, :integer
  end
end
