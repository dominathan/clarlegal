class CreateBillings < ActiveRecord::Migration
  def change
    create_table :billings do |t|
      t.string :name
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip_code
      t.references :client, index: true

      t.timestamps
    end
  end
end
