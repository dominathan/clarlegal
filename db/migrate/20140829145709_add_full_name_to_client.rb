class AddFullNameToClient < ActiveRecord::Migration
  def change
    add_column :clients, :full_name, :string
  end
end
