class ChangePrimaryEmailTypeInCase < ActiveRecord::Migration
  def change
    change_column :cases, :primary_email, :string
  end
end
