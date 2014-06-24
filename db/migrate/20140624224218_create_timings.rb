class CreateTimings < ActiveRecord::Migration
  def change
    create_table :timings do |t|
      t.references :case, index: true
      t.date :date_openend
      t.date :estimated_conclusion_date
      t.date :key_date

      t.timestamps
    end
  end
end
