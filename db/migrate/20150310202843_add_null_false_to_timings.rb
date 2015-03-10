class AddNullFalseToTimings < ActiveRecord::Migration
  def change
    change_column_null :timings, :estimated_conclusion_fast, false
    change_column_null :timings, :estimated_conclusion_expected, false
    change_column_null :timings, :estimated_conclusion_slow, false
  end
end
