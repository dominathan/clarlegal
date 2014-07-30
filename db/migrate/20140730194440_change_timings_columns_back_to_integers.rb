class ChangeTimingsColumnsBackToIntegers < ActiveRecord::Migration
  def change
    remove_column :timings, :estimated_conclusion_fast
    remove_column :timings, :estimated_conclusion_expected
    remove_column :timings, :estimated_conclusion_slow

    add_column :timings, :estimated_conclusion_fast, :integer
    add_column :timings, :estimated_conclusion_expected, :integer
    add_column :timings, :estimated_conclusion_slow, :integer
  end
end
