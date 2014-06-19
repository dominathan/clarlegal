class Client < ActiveRecord::Base
  belongs_to :user

  # validates :client_name, presence: true
  # validates :client_street_address, presence: true
  # validates :client_city_address, presence: true
  # validates :client_state_address, presence: true
  # validates :client_zip_code, presence: true
  # validates :client_phone_number, presence: true
  # validates :client_email, presence: true


end
