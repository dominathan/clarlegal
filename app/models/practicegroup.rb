class Practicegroup < ActiveRecord::Base
  belongs_to :lawfirm

  validates :lawfirm_id, :group_name, presence: true
  validates :group_name, uniqueness: {scope: :lawfirm_id}

end
