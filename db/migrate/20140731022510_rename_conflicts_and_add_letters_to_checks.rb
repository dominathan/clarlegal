class RenameConflictsAndAddLettersToChecks < ActiveRecord::Migration
  def change
    add_column :checks, :conflict_date, :date
    remove_column :checks, :conflict_check
    add_column :checks, :conflict_check, :boolean
    remove_column :checks, :retention_letter
    add_column :checks, :referring_engagement_letter, :date
    add_column :checks, :client_engagement_letter, :date
  end
end
