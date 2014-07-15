class RemoveBillingInfoFromClientModel < ActiveRecord::Migration
  def change
    remove_column :clients, :client_billing_name
    remove_column :clients, :client_billing_street_address
    remove_column :clients, :client_billing_city_address
    remove_column :clients, :client_billing_state_address
    remove_column :clients, :client_billing_zip_code
  end
end
