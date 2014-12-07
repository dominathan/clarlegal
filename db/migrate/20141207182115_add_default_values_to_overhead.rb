class AddDefaultValuesToOverhead < ActiveRecord::Migration
  def change
    change_column_default :overheads, :rent, 0
    change_column_default :overheads, :utilities, 0
    change_column_default :overheads, :technology, 0
    change_column_default :overheads, :hard_costs, 0
    change_column_default :overheads, :guaranteed_salaries, 0
    change_column_default :overheads, :other, 0
  end
end
