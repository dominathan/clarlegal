class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :jurisdiction
      t.string :judge
      t.references :case, index: true

      t.timestamps
    end
  end
end
