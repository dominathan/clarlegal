class CreateFixedFees < ActiveRecord::Migration
  def change
    create_table :fixed_fees do |t|
      t.references :case, index: true
      t.float :expected_remaining
      t.float :conversion_rate
      t.float :actual_earned

      t.timestamps
    end
  end
end
