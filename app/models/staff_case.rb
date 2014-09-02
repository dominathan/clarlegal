class StaffCase < ActiveRecord::Base
  belongs_to :staffing
  belongs_to :case

  def self.add_to_staff_master_list(staff_array,case_id)
    for stf in staff_array
      binding.pry
      StaffCase.create!(staffing_id: stf['staffing_id'], case_id: case_id, current_case: true,
                hours_expected: stf['hours_expected'] || nil,
                hours_actual: stf['hours_actual'] || nil)
    end
  end
end
