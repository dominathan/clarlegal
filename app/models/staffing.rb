class Staffing < ActiveRecord::Base

  belongs_to :lawfirm
  has_many :staffs

  attr_accessor :new_position #for user to enter new position if applicable

  validates :lawfirm_id, :position, :first_name, :last_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i || ""
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }

  def self.all_positions(user)
    position_list = StaticInformation::POSITION_LIST.concat(user.lawfirm.staffings.load
                                                    .collect! { |person| person.position } )
                                                    .compact.uniq.sort!
  end

  def self.all_full_name_last_first(user)
    #used in _staff_fields for collection select of LastName, FirstName
    final_name_list = []
    user.lawfirm.staffings.each do |name|
      final_name_list << Staffing.full_name_last_first(name)
    end
    final_name_list.sort
  end

  def self.all_full_names_last_first_with_ids(user)
    final_name_list = []
    user.lawfirm.staffings.each do |name|
      final_name_list << [name.full_name_last_first, name.id]
    end
    final_name_list.sort
  end

  def full_name_last_first
    myarr = [self.last_name, self.first_name, self.middle_initial ? self.middle_initial : ""]
    myarr[0..-2].join(", ")+(" ")+myarr[-1]
  end

  #return list of open cases by staffing_id
  def self.open_cases_by_staffing(staffing_id)
    caselist = Staff.where(staffing_id: staffing_id).collect(&:case_id)
    return Case.where(id: caselist, open: true)
  end

    def self.closed_cases_by_staffing(staffing_id)
    caselist = Staff.where(staffing_id: staffing_id).collect(&:case_id)
    return Case.where(id: caselist, open: false)
  end

end
