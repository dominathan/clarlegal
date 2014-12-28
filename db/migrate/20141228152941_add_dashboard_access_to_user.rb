class AddDashboardAccessToUser < ActiveRecord::Migration
  def change
    add_column :users, :dashboard_access, :boolean
  end
end
