class FixOpenendInTiming < ActiveRecord::Migration
  def change
    rename_column :timings, :date_openend, :date_opened
  end
end
