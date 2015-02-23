class AddExternalIDtToClient < ActiveRecord::Migration
  def change
    add_column :clients, :external_id, :string
  end
end
