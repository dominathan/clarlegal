class AddExternalIdToCasetypes < ActiveRecord::Migration
  def change
    add_column :case_types, :external_id, :string
  end
end
