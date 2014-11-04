class CaseType < ActiveRecord::Base
  belongs_to :lawfirm

  validates :lawfirm_id, presence: true
  validates :mat_ref, uniqueness: {scope: :lawfirm_id}
end
