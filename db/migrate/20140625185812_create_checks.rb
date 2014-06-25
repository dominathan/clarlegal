class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.references :case, index: true
      t.date :conflict_check
      t.date :retention_letter

      t.timestamps
    end
  end
end
