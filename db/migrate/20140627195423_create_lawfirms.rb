class CreateLawfirms < ActiveRecord::Migration
  def change
    create_table :lawfirms do |t|
      t.string :firm_name
      t.string :password_digest

      t.timestamps
    end
  end
end
