class Staff < ActiveRecord::Base
  belongs_to :case
  belongs_to :staffing

  validates :staffing_id, presence: true

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
    return hours_actual
  end

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
    return hours_expected
  end

  def self.staff_total_hours_actual(case_id,staffing_id)
    if Staff.where(:case_id => case_id, :staffing_id => staffing_id).last.hours_actual
      return Staff.where(:case_id => case_id, :staffing_id => staffing_id).last.hours_actual
    else
      return 0
    end
  end

  def self.staff_total_hours_expected(case_id, staffing_id)
    if Staff.where(:case_id => case_id, :staffing_id => staffing_id).last.hours_expected
      return Staff.where(:case_id => case_id, :staffing_id => staffing_id).last.hours_expected
    else
      return 0
    end
  end

end
