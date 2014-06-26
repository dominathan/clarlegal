class Case < ActiveRecord::Base
  belongs_to :client
  belongs_to :user
  has_many :fee
  has_many :staff
  has_many :timing
  has_many :origination
  has_many :venue
  has_many :check

  validates :client_id, presence: true

  MATTER_REFERENCES = ['Medical Malpractice', 'Insurance Fraud', 'Automotive', "Worker's Compensation"]
  PRACTICE_GROUP = ['Medical', 'Consumer', 'Automotive', 'Other']

end
