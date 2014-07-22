class AddCaseReferencesToCloseout < ActiveRecord::Migration
  def change
    add_column :closeouts, :case_id, :integer
    add_index :closeouts, :case_id
  end
end
