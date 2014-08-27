class Staffing < ActiveRecord::Base

  belongs_to :lawfirm
  has_many :staffs

  validates :lawfirm_id, presence: true
  STARTING_LIST = ['Managing Member', 'Partner','Counsel','Contract Attorney',
                   'Staff Attorney','Paralegal','Secretary']
  def self.all_positions(user)
    position_list = STARTING_LIST.concat(user.lawfirm.staffings.all.collect! { |person| person.position } ).uniq.sort!
  end


end
