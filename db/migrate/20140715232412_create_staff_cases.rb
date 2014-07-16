class CreateStaffCases < ActiveRecord::Migration
  def change
    create_table :staff_cases do |t|
      t.references :staffing, index: true
      t.references :case, index: true
      t.boolean :current_case

      t.timestamps
    end
  end
end
