class ChangeTimingExpecationsFromIntegersToDate < ActiveRecord::Migration
  def change
    remove_column :timings, :estimated_conclusion_fast
    remove_column :timings, :estimated_conclusion_expected
    remove_column :timings, :estimated_conclusion_slow

    add_column :timings, :estimated_conclusion_fast, :date
    add_column :timings, :estimated_conclusion_expected, :date
    add_column :timings, :estimated_conclusion_slow, :date

  end
end
