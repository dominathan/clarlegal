class User < ActiveRecord::Base
  belongs_to :lawfirm
  has_many :clients
  has_many :cases, through: :clients

  attr_accessor :remember_token

  before_save { self.email = email.downcase }
  validates :first_name, presence: true
  validates :last_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 7 }

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end


  def self.full_name(user)
    [user.first_name, user.last_name].compact.join(" ")
  end

  def self.full_name_last_first(user)
    [user.last_name, user.first_name].compact.join(", ")
  end

  private

    # def create_remember_token
    #   self.remember_token = User.digest(User.new_remember_token)
    # end


end
