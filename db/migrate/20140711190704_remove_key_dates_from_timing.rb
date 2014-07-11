class RemoveKeyDatesFromTiming < ActiveRecord::Migration
  def change
    remove_column :timings, :key_date
  end
end
