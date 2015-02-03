class RenameUserIdToPrimaryEmailInCase < ActiveRecord::Migration
  def change
    rename_column :cases, :user_id, :primary_email
  end
end
