class Lawfirm < ActiveRecord::Base
  has_many :users
  has_many :practicegroups
  has_many :staffings
  has_many :clients, through: :users
  has_many :cases, through: :clients
  has_many :case_types
  has_many :originations, through: :cases
  has_many :overheads

  validates :firm_name, presence: true, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
end
