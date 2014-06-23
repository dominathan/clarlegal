class FixFeeTypeName < ActiveRecord::Migration
  def change
    rename_column :fees, :type, :fee_type
  end
end
