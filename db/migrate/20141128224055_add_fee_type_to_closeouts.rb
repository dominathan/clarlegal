class AddFeeTypeToCloseouts < ActiveRecord::Migration
  def change
    add_column :closeouts, :fee_type, :string
  end
end
