class ChangeStaffHoursFromStringsToIntegers < ActiveRecord::Migration
  def change
    remove_column :staffs, :hours_actual
    remove_column :staffs, :hours_expected
    add_column :staffs, :hours_actual, :integer
    add_column :staffs, :hours_expected, :integer
  end

end
