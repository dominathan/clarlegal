class Overhead < ActiveRecord::Base
  belongs_to :lawfirm

  validates :lawfirm_id, :rent, :utilities, :guaranteed_salaries, :hard_costs,
            :other, :billable_hours_per_lawyer, :number_of_billable_staff, :year, presence: true

  validates_uniqueness_of :year, :scope => :lawfirm


end
