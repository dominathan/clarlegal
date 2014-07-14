class AddActualHoursToStaff < ActiveRecord::Migration
  def change
    add_column :staffs, :hours_actual ,:string
  end
end
