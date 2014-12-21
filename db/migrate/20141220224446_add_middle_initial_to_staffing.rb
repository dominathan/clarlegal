class AddMiddleInitialToStaffing < ActiveRecord::Migration
  def change
    add_column :staffings, :middle_initial, :string
  end
end
