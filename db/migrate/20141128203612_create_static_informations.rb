class CreateStaticInformations < ActiveRecord::Migration
  def change
    create_table :static_informations do |t|

      t.timestamps
    end
  end
end
