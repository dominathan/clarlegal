class Staffing < ActiveRecord::Base
  belongs_to :lawfirm
  has_many :utilizations

  validates :lawfirm_id, presence: true

end
