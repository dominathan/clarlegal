class AddUserIdToCases < ActiveRecord::Migration
  def change
    add_column :cases, :user_id, :integer
  end
end
