class StaffCase < ActiveRecord::Base
  belongs_to :staffing
  belongs_to :case

  #this is called in cases_controller#new_case to add Staff to StaffCase.new
  def self.add_to_staff_master_list(staff_array,case_id)
    for stf in staff_array
      StaffCase.create!(staffing_id: stf['staffing_id'], case_id: case_id, current_case: true,
                hours_expected: stf['hours_expected'] || nil,
                hours_actual: stf['hours_actual'] || nil)
    end
  end

  #this is to collect hours actually worked for a specific case
  def self.case_total_hours_actual(case_id)
    hours_actual = 0
    staff_ids  = StaffCase.where(current_case: true, case_id: case_id).collect(&:staffing_id).uniq
    for id in staff_ids
      if StaffCase.where(current_case: true, case_id: case_id,
                        staffing_id: id).order(:updated_at).last.hours_actual != nil
        hours_actual += StaffCase.where(current_case: true, case_id: case_id,
                                      staffing_id: id).order(:updated_at).last.hours_actual
      else
        next
      end
    end
    hours_actual
  end

  #this is to collect hours actually worked for a specific case
  def self.case_total_hours_expected(case_id)
    hours_expected = 0
    staff_ids  = StaffCase.where(current_case: true, case_id: case_id).collect(&:staffing_id).uniq
    for id in staff_ids
      if StaffCase.where(current_case: true, case_id: case_id,
                        staffing_id: id).order(:updated_at).last.hours_expected != nil
        hours_expected += StaffCase.where(current_case: true, case_id: case_id,
                                      staffing_id: id).order(:updated_at).last.hours_expected
      else
        next
      end
    end
    hours_expected
  end

end
