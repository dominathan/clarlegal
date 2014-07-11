class RenameTimingConclusionColumns < ActiveRecord::Migration
  def change
    rename_column :timings, :estimated_conclusion_high, :estimated_conclusion_fast
    rename_column :timings, :estimated_conclusion_med, :estimated_conclusion_expected
    rename_column :timings, :estimated_conclusion_low, :estimated_conclusion_slow
  end
end
