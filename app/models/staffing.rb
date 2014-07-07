class Staffing < ActiveRecord::Base
  belongs_to :lawfirm
  has_many :staffs

  validates :lawfirm_id, presence: true

end
