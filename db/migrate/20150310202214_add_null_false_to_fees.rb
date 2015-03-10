class AddNullFalseToFees < ActiveRecord::Migration
  def change
    change_column_null      :fees, :high_estimate, false
    change_column_null      :fees, :medium_estimate, false
    change_column_null      :fees, :low_estimate, false
    change_column_null      :fees, :cost_estimate, false
    change_column_null      :fees, :referral_percentage, false
    change_column_default   :fees, :referral_percentage, 0
    change_column_null      :fees, :high_referral, false
    change_column_null      :fees, :medium_referral, false
    change_column_null      :fees, :low_referral, false
  end
end
