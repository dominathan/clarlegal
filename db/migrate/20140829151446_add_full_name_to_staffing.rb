class AddFullNameToStaffing < ActiveRecord::Migration
  def change
    add_column :staffings, :full_name, :string
  end
end
