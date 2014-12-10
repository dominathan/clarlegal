class CreateRelatedCases < ActiveRecord::Migration
  def change
    create_table :related_cases do |t|
      t.references :case, index: true
      t.references :related_case, index: true

      t.timestamps
    end
  end
end
