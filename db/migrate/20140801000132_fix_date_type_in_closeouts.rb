class FixDateTypeInCloseouts < ActiveRecord::Migration
  def change
    remove_column :closeouts, :date_fee_received
    add_column :closeouts, :date_fee_received, :date
  end
end
