class AddHoursToStaffCase < ActiveRecord::Migration
  def change
    add_column :staff_cases, :hours_expected, :integer
    add_column :staff_cases, :hours_actual, :integer
  end
end
