class AddNullFalseToCloseouts < ActiveRecord::Migration
  def change
    change_column_null :closeouts, :total_recovery, false
    change_column_null :closeouts, :total_gross_fee_received, false
    change_column_null :closeouts, :total_out_of_pocket_expenses, false
    change_column_null :closeouts, :referring_fees_paid, false
    change_column_null :closeouts, :total_fee_received, false
  end
end
