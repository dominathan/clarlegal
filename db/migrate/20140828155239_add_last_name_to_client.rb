class AddLastNameToClient < ActiveRecord::Migration
  def change
    add_column :clients, :last_name, :string
  end
end
