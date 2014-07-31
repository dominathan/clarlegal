class AddEngagementLetterDateAndClientEngagementDateToChecks < ActiveRecord::Migration
  def change
    rename_column :checks, :referring_engagement_letter, :referring_engagement_letter_date
    rename_column :checks, :client_engagement_letter, :client_engagement_letter_date
    add_column :checks, :referring_engagement_letter, :boolean
    add_column :checks, :client_engagement_letter, :boolean
  end
end
