class Lawfirm < ActiveRecord::Base
  has_many :users
  has_many :practicegroups

  validates :firm_name, presence: true, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
end
