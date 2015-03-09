class ChangeRetainerToFloatInFees < ActiveRecord::Migration
  def change
    change_column :fees, :referral, :float
  end
end
