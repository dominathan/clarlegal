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

  #get the very last update of a specific case, used in staffs_controller#index
  def self.case_last_update(case_id)
    StaffCase.where(current_case: true, case_id: case_id).order(:updated_at).last.updated_at.strftime("%b %d, %y")
  end

  #collect datetimes of all updates to a particular case
  def self.all_case_updates(case_id)
    StaffCase.where(case_id: case_id).collect(&:updated_at).uniq.sort
  end

  def self.staffing_actual_hours_over_time(case_id)
  end

  #collect actual hours and expected hours based on self.all_case_updates
  def self.actual_expected_hours_over_time(case_id)
    actual_list = []
    expected_list = []
    update_list = StaffCase.all_case_updates(case_id)
    current_datetime_position = 0
    for date_time in update_list
      delta = 0
      actual_hours = 0
      expected_hours = 0
      StaffCase.where(case_id: case_id, updated_at: date_time).each do |stf|
        if stf.hours_actual
          actual_hours += stf.hours_actual
        end
        # if stf.hours_expected
        #   expected_hours += stf.hours_expected
        # end
      end
      actual_list << actual_hours
      binding.pry
      if current_datetime_position == 0
        delta =  actual_list[0]
      else
        delta = actual_list[current_datetime_position] - actual_list[current_datetime_position - 1]
        if delta > 0
          actual_list[current_datetime_position] = actual_list[current_datetime_position - 1] + delta
          binding.pry
        end
      #expected_list << expected_hours
      end
      binding.pry
      current_datetime_position += 1
    end
    actual_list
  end



end
