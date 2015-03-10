class RemoveDefaultValueFromPercentage < ActiveRecord::Migration
  def change
    change_column_default :fees, :referral_percentage, nil
  end
end
