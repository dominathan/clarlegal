class User < ActiveRecord::Base
  belongs_to :lawfirm
  has_many   :clients
  has_many   :cases, through: :clients

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save   :downcase_email
  before_create :create_activation_digest

  validates :first_name, :last_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 7 }

  delegate :full_name, :full_name_last_first, to: :name

  def name
    NamesHelper::Name.new(first_name, middle_initial, last_name)
  end

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
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  #activate user account
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver
  end

  #set password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  #send password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver
  end

  #send lawfirm password reset email
  def send_lawfirm_password_reset_email
    LawfirmMailer.password_reset(self).deliver
  end

  #Return true if password reset has expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def sign_in_incrementer
    increment! :signin_counter
  end

  private

    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
