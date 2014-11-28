class AddCompanyAndCountryToClients < ActiveRecord::Migration
  def change
    add_column :clients, :company, :string
    add_column :clients, :country, :string
  end
end
