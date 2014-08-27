class AddPracticegroupsAndPhonenumberToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone_number, :string
    add_column :users, :practice_groups, :string
  end
end
