class Overhead < ActiveRecord::Base
  belongs_to :lawfirm


  validates :lawfirm_id, presence: true
  validates :rent, presence: true
  validates :utilities, presence: true
  validates :guaranteed_salaries, presence: true
  validates :hard_costs, presence: true
  validates :other, presence: true
  validates :billable_hours_per_lawyer, presence: true
  validates :number_of_billable_staff, presence: true


end
