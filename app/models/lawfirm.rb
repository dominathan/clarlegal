class Lawfirm < ActiveRecord::Base
  has_many :users
  has_many :practicegroups
  has_many :staffings
  has_many :clients, through: :users
  has_many :cases, through: :clients
  has_many :case_types
  has_many :originations, through: :cases
  has_many :overheads

  attr_accessor :reset_token

  validates :firm_name, presence: true, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  #set password reset attributes
  def create_reset_digest
    self.reset_token = Lawfirm.new_token
    update_attribute(:reset_digest, Lawfirm.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

    #Return true if password reset has expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

end
