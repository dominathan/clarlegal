class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :client_name
      t.string :client_street_address
      t.string :client_city_address
      t.string :client_state_address
      t.string :client_zip_code
      t.string :client_billing_name
      t.string :client_billing_street_address
      t.string :client_billing_city_address
      t.string :client_billing_state_address
      t.string :client_billing_zip_code
      t.string :client_phone_number
      t.string :client_fax_number

      t.timestamps
    end
  end
end
