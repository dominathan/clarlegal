class ChangeDefaultHoursInStaffs < ActiveRecord::Migration
  def change
    change_column_default :staffs, :hours_actual, 0
    change_column_default :staffs, :hours_expected, 0
  end
end
