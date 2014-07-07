class Staff < ActiveRecord::Base
  belongs_to :case
  has_many :utilizations
  accepts_nested_attributes_for :utilizations

  validates :case_id, presence: true
end
