class AddStaffingReferencesToStaff < ActiveRecord::Migration
  def change
    add_reference :staffs, :staffing, index: true
  end
end
