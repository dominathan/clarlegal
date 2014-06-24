class Fee < ActiveRecord::Base
  belongs_to :case

  validates :case_id, presence: true
end
