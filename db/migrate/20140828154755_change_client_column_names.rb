class ChangeClientColumnNames < ActiveRecord::Migration
  def change
    change_table :clients do |t|
      t.rename :client_name, :first_name
      t.rename :client_street_address, :street_address
      t.rename :client_city_address, :city_address
      t.rename :client_state_address, :state_address
      t.rename :client_zip_code, :zip_code
      t.rename :client_phone_number, :phone_number
      t.rename :client_fax_number, :fax_number
      t.rename :client_email, :email
    end
  end
end
