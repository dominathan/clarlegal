class Case < ActiveRecord::Base
  belongs_to :client
  has_many :fees

  validates :client_id, presence: true
end
