class ChangeRetainerToIntegerInFees < ActiveRecord::Migration
  def change
    remove_column :fees, :retainer
    add_column :fees, :retainer, :integer
  end
end
