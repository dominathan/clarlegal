class AddDefaultsToFees < ActiveRecord::Migration
  def change
    change_column_default :fees, :high_estimate, 0
    change_column_default :fees, :medium_estimate, 0
    change_column_default :fees, :low_estimate, 0
    change_column_default :fees, :cost_estimate, 0
    change_column_default :fees, :retainer, 0
    change_column_default :fees, :referral, 0

    change_column_default :closeouts, :total_recovery, 0
    change_column_default :closeouts, :total_gross_fee_received, 0
    change_column_default :closeouts, :total_out_of_pocket_expenses, 0
    change_column_default :closeouts, :referring_fees_paid, 0
    change_column_default :closeouts, :total_fee_received, 0
  end
end
