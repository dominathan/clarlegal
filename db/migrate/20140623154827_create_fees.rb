class CreateFees < ActiveRecord::Migration
  def change
    create_table :fees do |t|
      t.integer :case_id
      t.string :type
      t.decimal :high_estimate
      t.decimal :medium_estimate
      t.decimal :low_estimate
      t.string :payment_likelihood
      t.string :retainer
      t.decimal :cost_estimate

      t.timestamps
    end
    add_index :fees, :case_id
  end
end
