class User < ActiveRecord::Base
  belongs_to :lawfirm
  has_many :clients
  has_many :cases, through: :clients

  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :first_name, presence: true
  validates :last_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 7 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def self.full_name(user)
    [user.first_name, user.last_name].compact.join(" ")
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end


end
