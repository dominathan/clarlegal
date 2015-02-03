class AddEmailToStaffing < ActiveRecord::Migration
  def change
    add_column :staffings, :email, :string
  end
end
