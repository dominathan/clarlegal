class AddYearToOverhead < ActiveRecord::Migration
  def change
    add_column :overheads, :year, :date
  end
end
