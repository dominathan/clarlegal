class AddCaseReferencestoOrigination < ActiveRecord::Migration
  def change
    add_column :originations, :case_id, :integer
    add_index :originations, :case_id
  end
end
