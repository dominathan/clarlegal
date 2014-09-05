class Staff < ActiveRecord::Base
  belongs_to :case
  belongs_to :staffing

  # validates :case_id, presence: true
  # validates :staffing_id, presence: true

  #this is to collect hours actually worked for a specific case
  def self.case_total_hours_actual(case_id)
    hours_actual = 0
    staff_ids  = Staff.where(case_id: case_id).collect(&:staffing_id).uniq
    for id in staff_ids
      if Staff.where(case_id: case_id,
                    staffing_id: id).order(:updated_at).last.hours_actual != nil
        hours_actual += Staff.where(case_id: case_id,
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
    staff_ids  = Staff.where(case_id: case_id).collect(&:staffing_id).uniq
    for id in staff_ids
      if Staff.where(case_id: case_id,
                        staffing_id: id).order(:updated_at).last.hours_expected != nil
        hours_expected += Staff.where(case_id: case_id, staffing_id: id).order(:updated_at).last.hours_expected
      else
        next
      end
    end
    hours_expected
  end

end
