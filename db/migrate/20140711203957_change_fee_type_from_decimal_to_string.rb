class ChangeFeeTypeFromDecimalToString < ActiveRecord::Migration
  def change
    change_column :fees, :high_estimate, :integer
    change_column :fees, :medium_estimate, :integer
    change_column :fees, :low_estimate, :integer
    change_column :fees, :cost_estimate, :integer
  end
end
