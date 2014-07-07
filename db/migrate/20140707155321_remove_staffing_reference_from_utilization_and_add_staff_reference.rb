class RemoveStaffingReferenceFromUtilizationAndAddStaffReference < ActiveRecord::Migration
  def change
    remove_column :utilizations, :staffing_id
    add_reference :utilizations, :staffing, index: true
  end
end
