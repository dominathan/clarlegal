class Case < ActiveRecord::Base
  belongs_to :client
  has_many :fee
  has_many :staff

  validates :client_id, presence: true
end
