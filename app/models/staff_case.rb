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

  #this is to collect hours expected to be worked for a specific case
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

  #collect datetimes of all updates to a particular case
  def self.all_case_updates(case_id)
    StaffCase.where(case_id: case_id).collect(&:updated_at).uniq.sort
  end

  #collect actual hours and expected hours based on self.all_case_updates
  def self.actual_expected_hours_over_time(case_id)
    actual_list = []
    expected_list = []
    update_list = StaffCase.all_case_updates(case_id)
    for date_time in update_list
      actual_hours = 0
      expected_hours = 0
      StaffCase.where(case_id: case_id, updated_at: date_time).each do |stf|
        if stf.hours_actual
          actual_hours += stf.hours_actual
        end
        if stf.hours_expected
          expected_hours += stf.hours_expected
        end
      end
      actual_list << actual_hours
      #expected_list << expected_hours
      binding.pry
    end
    return [actual_list.prepend("Actual Hours"),expected_hours.prepend("Expected Hours")]
    #--------------fix--------------------
    #actual_list = actual_list.prepend('Actual Hours')
    #expected_list = expected_list.prepend('Expected Hours')
    #@hash_file = zipped_file.map {|name,values| {'name' => name, 'data'  => values } }.to_json
    #--------------fix--------------------
  end

end
