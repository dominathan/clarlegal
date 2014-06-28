class CreateStaffings < ActiveRecord::Migration
  def change
    create_table :staffings do |t|
      t.references :lawfirm, index: true
      t.string :first_name
      t.string :last_name
      t.string :position

      t.timestamps
    end
  end
end
