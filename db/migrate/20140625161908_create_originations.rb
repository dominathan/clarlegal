class CreateOriginations < ActiveRecord::Migration
  def change
    create_table :originations do |t|
      t.string :referral_source
      t.string :exisitng_client
      t.string :other_source

      t.timestamps
    end
  end
end
