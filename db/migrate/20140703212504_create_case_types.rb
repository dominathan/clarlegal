class CreateCaseTypes < ActiveRecord::Migration
  def change
    create_table :case_types do |t|
      t.references :lawfirm, index: true
      t.string :mat_ref

      t.timestamps
    end
  end
end
