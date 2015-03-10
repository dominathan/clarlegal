class NullFalseToCases < ActiveRecord::Migration
  def change
    change_column_null :cases, :client_id, false
  end
end
