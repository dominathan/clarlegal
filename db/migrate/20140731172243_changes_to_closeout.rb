class ChangesToCloseout < ActiveRecord::Migration
  def change
    remove_column :closeouts, :total_revenue
    remove_column :closeouts, :total_cost
    add_column :closeouts, :total_recovery, :integer
    add_column :closeouts, :total_gross_fee_received, :integer
    add_column :closeouts, :total_out_of_pocket_expenses, :integer
    add_column :closeouts, :referring_fees_paid, :integer
    add_column :closeouts, :total_fee_receieved, :integer
    add_column :closeouts, :date_fee_received, :integer
  end
end
