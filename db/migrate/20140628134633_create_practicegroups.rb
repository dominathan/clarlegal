class CreatePracticegroups < ActiveRecord::Migration
  def change
    create_table :practicegroups do |t|
      t.references :lawfirm, index: true
      t.string :group_name

      t.timestamps
    end
  end
end
