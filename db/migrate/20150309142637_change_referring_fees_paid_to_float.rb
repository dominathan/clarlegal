class ChangeReferringFeesPaidToFloat < ActiveRecord::Migration
  def change
    change_column_null :fees, :referral, :false
    change_column_null :fees, :high_estimate, :false
    change_column_null :fees, :medium_estimate, :false
    change_column_null :fees, :low_estimate, :false
    change_column_null :fees, :retainer, :false
    change_column_null :fees, :cost_estimate, :false
    change_column :fees, :referral, :integer
  end
end
