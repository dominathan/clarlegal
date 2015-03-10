class Timing < ActiveRecord::Base

  belongs_to :case

  #validates :case_id, presence: true
  validates :estimated_conclusion_expected, presence:  { message: "is required" }
  validates :estimated_conclusion_fast, presence:  { message: "is required" }
  validates :estimated_conclusion_slow, presence:  { message: "is required" }

end
