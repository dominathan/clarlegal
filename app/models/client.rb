class Client < ActiveRecord::Base
  belongs_to :user
  has_many :cases
  has_many :billings

  accepts_nested_attributes_for :billings, :reject_if => :all_blank
  #all attributes must be filled for billings or it will not save

  validates :user_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i || ""
  validates :email, format: { with: VALID_EMAIL_REGEX }

  def self.all_full_name_last_first(user)
    #used in _staff_fields for collection select of LastName, FirstName
    final_name_list = []
    user.lawfirm.clients.each do |name|
      final_name_list << [name.last_name, name.first_name].compact.join(", ")
    end
    final_name_list.sort
  end

  def self.full_name_last_first(first_name, last_name)
    [last_name, first_name].compact.join(", ")
  end

end
