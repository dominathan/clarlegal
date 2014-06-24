class Case < ActiveRecord::Base
  belongs_to :client
  has_many :fee

  validates :client_id, presence: true
end
