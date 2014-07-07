class AddPercentAndHoursToStaff < ActiveRecord::Migration
  def change
    add_column :staffs, :percent_utilization, :integer
    add_column :staffs, :hours_expected, :integer
  end
end
