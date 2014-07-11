class AddHighMedLowTimeEstimatesToTiming < ActiveRecord::Migration
  def change
    remove_column :timings, :estimated_conclusion_date
    add_column :timings, :estimated_conclusion_high, :integer
    add_column :timings, :estimated_conclusion_med, :integer
    add_column :timings, :estimated_conclusion_low, :integer
  end
end
