class Staffing < ActiveRecord::Base

  belongs_to :lawfirm
  has_many :staffs

  attr_accessor :new_position #for user to enter new position if applicable

  validates :lawfirm_id, presence: true
  STARTING_LIST = ['Managing Member', 'Partner','Counsel','Contract Attorney',
                   'Staff Attorney','Paralegal','Secretary', 'Responsible Attorney']
  def self.all_positions(user)
    position_list = STARTING_LIST.concat(user.lawfirm.staffings.all.collect! { |person| person.position } ).uniq.sort!
  end

  def self.all_full_name_last_first(user)
    #used in _staff_fields for collection select of LastName, FirstName
    final_name_list = []
    user.lawfirm.staffings.each do |name|
      final_name_list << [name.last_name, name.first_name].compact.join(", ")
    end
    final_name_list.sort
  end



end
