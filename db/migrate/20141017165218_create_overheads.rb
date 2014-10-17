class CreateOverheads < ActiveRecord::Migration
  def change
    create_table :overheads do |t|
      t.integer :rent
      t.integer :utilities
      t.integer :technology
      t.integer :hard_costs
      t.integer :guaranteed_salaries
      t.integer :other
      t.integer :billable_hours_per_lawyer
      t.integer :number_of_billable_staff

      t.timestamps
    end
  end
end
