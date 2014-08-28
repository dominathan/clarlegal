class AddFirstNameLastNameToStaffing < ActiveRecord::Migration
  def change
    add_column :staffings, :first_name, :string
    add_column :staffings, :last_name, :string
    remove_column :staffings, :full_name
  end
end
