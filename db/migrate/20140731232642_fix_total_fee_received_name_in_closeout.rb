class FixTotalFeeReceivedNameInCloseout < ActiveRecord::Migration
  def change
    rename_column :closeouts, :total_fee_receieved, :total_fee_received
  end
end
