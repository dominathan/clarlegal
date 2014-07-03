class RemoveItemsFromStaff < ActiveRecord::Migration
  def change
    remove_column :staffs, :responsible_attorney
    remove_column :staffs, :assigned_attorney_1
    remove_column :staffs, :assigned_attorney_2
    remove_column :staffs, :assigned_staff_1
    remove_column :staffs, :assigned_staff_2

    add_column :staffs, :name, :string
    add_column :staffs, :position, :string
  end
end
