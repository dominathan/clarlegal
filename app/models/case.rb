class Case < ActiveRecord::Base
  belongs_to :client
  has_one :fee

  validates :client_id, presence: true
end
