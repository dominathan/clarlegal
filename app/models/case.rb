class Case < ActiveRecord::Base
  belongs_to :lawfirm
  belongs_to :client
  belongs_to :user

  has_many :fee
  has_many :fees
  accepts_nested_attributes_for :fees

  has_many :staff
  has_many :staffs
  accepts_nested_attributes_for :staffs

  has_many :timing
  has_many :timings
  accepts_nested_attributes_for :timings

  has_many :originations
  accepts_nested_attributes_for :originations

  has_many :venues
  accepts_nested_attributes_for :venues

  has_many :checks
  accepts_nested_attributes_for :checks

  has_many :closeouts



  validates :client_id, presence: true

  MATTER_REFERENCES = ['Medical Malpractice', 'Insurance Fraud', 'Automotive', "Worker's Compensation"]



end
