class Timing < ActiveRecord::Base
  belongs_to :case

  #validates :case_id, presence: true
  # validates :estimated_conclusion_expected, presence: true
  # validates :estimated_conclusion_fast, presence: true
  # validates :estimated_conclusion_slow, presence: true
end
