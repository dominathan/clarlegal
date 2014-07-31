class RemoveOtherAddSourceOrigination < ActiveRecord::Migration
  def change
    remove_column :originations, :existing_client
    remove_column :originations, :other_source
    add_column :originations, :source_description, :string
  end
end
