class AddUserIdColumnToCases < ActiveRecord::Migration
  def change
    add_reference :cases, :user, index: true
  end
end
