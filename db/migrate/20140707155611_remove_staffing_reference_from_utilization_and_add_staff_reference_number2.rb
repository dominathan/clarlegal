class RemoveStaffingReferenceFromUtilizationAndAddStaffReferenceNumber2 < ActiveRecord::Migration
  def change
    remove_column :utilizations, :staffing_id
    add_reference :utilizations, :staff, index: true
  end
end
