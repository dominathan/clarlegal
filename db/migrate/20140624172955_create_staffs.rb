class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.integer :case_id
      t.string :responsible_attorney
      t.string :assigned_attorney_1
      t.string :assigned_attorney_2
      t.string :assigned_staff_1
      t.string :assigned_staff_2

      t.timestamps
    end
    add_index :staffs, :case_id
  end
end
