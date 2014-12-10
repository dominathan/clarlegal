class CreateMatters < ActiveRecord::Migration
  def change
    create_table :matters do |t|
      t.references :case, index: true
      t.references :case_type, index: true

      t.timestamps
    end
  end
end
