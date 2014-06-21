class CreateCases < ActiveRecord::Migration
  def change
    create_table :cases do |t|
      t.string :matter_reference
      t.text :description
      t.string :practice_group
      t.integer :client_id

      t.timestamps
    end
    add_index :cases, :client_id
  end
end
