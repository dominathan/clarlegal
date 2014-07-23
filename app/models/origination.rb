class Origination < ActiveRecord::Base
  belongs_to :case

  #validates :case_id, presence: true

  EXISTING_CLIENT_CHOICES = ['Yes','No']
end
