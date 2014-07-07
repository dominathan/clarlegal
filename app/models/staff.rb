class Staff < ActiveRecord::Base
  belongs_to :case
  has_many :utilizations

  validates :case_id, presence: true
end
