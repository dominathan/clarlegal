class RenameCityAddressToCityInClients < ActiveRecord::Migration
  def change
    rename_column :clients, :city_address, :city
    rename_column :clients, :state_address, :state
  end
end
