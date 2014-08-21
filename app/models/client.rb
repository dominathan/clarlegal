class Client < ActiveRecord::Base
  belongs_to :user
  belongs_to :lawfirm
  has_many :cases
  has_many :billings

  accepts_nested_attributes_for :billings, :reject_if => :all_blank

  validates :user_id, presence: true
  validates :client_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i || ""
  validates :client_email, format: { with: VALID_EMAIL_REGEX }

end
