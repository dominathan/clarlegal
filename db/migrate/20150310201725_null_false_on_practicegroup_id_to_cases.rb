class NullFalseOnPracticegroupIdToCases < ActiveRecord::Migration
  def change
    change_column_null  :cases, :practicegroup_id, false
  end
end
