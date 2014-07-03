class Utilization < ActiveRecord::Base
  belongs_to :case
  belongs_to :staffing

  validates :case_id, presence: true
  validates :staffing_id, presence: true
end
