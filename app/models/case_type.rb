class CaseType < ActiveRecord::Base
  belongs_to :lawfirm

  validates :lawfirm_id, presence: true
end
