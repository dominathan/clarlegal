class AddCaseNametoCases < ActiveRecord::Migration
  def change
    add_column :cases, :name, :string
  end
end
