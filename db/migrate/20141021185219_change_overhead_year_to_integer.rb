class ChangeOverheadYearToInteger < ActiveRecord::Migration
  def change
    remove_column :overheads, :year
    add_column :overheads, :year, :integer
  end
end
