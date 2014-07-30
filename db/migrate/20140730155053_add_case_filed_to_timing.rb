class AddCaseFiledToTiming < ActiveRecord::Migration
  def change
    add_column :timings, :case_filed, :date
  end
end
