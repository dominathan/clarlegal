class Staffing < ActiveRecord::Base
  belongs_to :lawfirm
  has_many :staffs

  validates :lawfirm_id, presence: true

  def self.all_positions
    position_list = Staffing.all.collect! { |person| person.position }
    position_list =  position_list.uniq!
  end


end
