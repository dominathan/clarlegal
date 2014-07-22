class AddOpenToCase < ActiveRecord::Migration
  def change
    add_column :cases, :open, :boolean
  end
end
