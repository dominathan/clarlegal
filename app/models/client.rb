class Client < ActiveRecord::Base
  belongs_to :user
  belongs_to :lawfirm, :through => :users
  has_many :cases

  validates :user_id, presence: true
  validates :client_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i || ""
  validates :client_email, format: { with: VALID_EMAIL_REGEX }

end
