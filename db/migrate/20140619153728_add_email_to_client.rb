class AddEmailToClient < ActiveRecord::Migration
  def change
    add_column :clients, :client_email, :string
  end
end
