class AddDefaultZeroesToFees < ActiveRecord::Migration
  def change
    change_column_default :fees, :high_referral, 0
    change_column_default :fees, :medium_referral, 0
    change_column_default :fees, :low_referral, 0
  end
end
