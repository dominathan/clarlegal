class CreateUtilizations < ActiveRecord::Migration
  def change
    create_table :utilizations do |t|
      t.references :case, index: true
      t.references :staffing, index: true
      t.integer :percent
      t.integer :hours_expected

      t.timestamps
    end
  end
end
