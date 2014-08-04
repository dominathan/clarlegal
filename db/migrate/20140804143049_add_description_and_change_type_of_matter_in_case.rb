class AddDescriptionAndChangeTypeOfMatterInCase < ActiveRecord::Migration
  def change
    change_column :cases, :type_of_matter, :string
    add_column :cases, :description, :text
  end
end
