class CreateCloseouts < ActiveRecord::Migration
  def change
    create_table :closeouts do |t|
      t.date :date
      t.integer :total_revenue
      t.integer :total_cost

      t.timestamps
    end
  end
end
