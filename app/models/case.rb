class Case < ActiveRecord::Base
  belongs_to :client
  has_many :fee
  has_many :staff

  validates :client_id, presence: true

  MATTER_REFERENCES = ['Medical Malpractice', 'Insurance Fraud', 'Automotive', "Worker's Compensation"]
  PRACTICE_GROUP = ['Medical', 'Consumer', 'Automotive', 'Other']

end
