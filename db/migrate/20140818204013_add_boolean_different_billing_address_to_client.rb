class AddBooleanDifferentBillingAddressToClient < ActiveRecord::Migration
  def change
    add_column :clients, :different_billing, :boolean
  end
end
