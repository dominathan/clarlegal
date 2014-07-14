class AddHourlyRateToStaffing < ActiveRecord::Migration
  def change
    add_column :staffings, :hourly_rate, :integer
  end
end
