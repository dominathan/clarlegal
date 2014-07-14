class MakeNameJustOneFormInStaffing < ActiveRecord::Migration
  def change
    remove_column :staffings, :first_name
    remove_column :staffings, :last_name
    add_column :staffings, :full_name, :string
  end
end
