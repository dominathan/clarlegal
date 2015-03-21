require 'csv'
class Staffing < ActiveRecord::Base

  belongs_to :lawfirm
  has_many :staffs

  attr_accessor :new_position

  validates :lawfirm_id, :position, :first_name, :last_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i || ""
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }

  delegate :full_name, :full_name_last_first, to: :name

  def name
    NamesHelper::Name.new(first_name, middle_initial, last_name)
  end

  def self.all_positions(user)
    position_list = StaticInformation::POSITION_LIST.concat(user.lawfirm.staffings.load
                                                    .collect! { |person| person.position } )
                                                    .compact.uniq.sort!
  end

  def self.all_full_names_last_first_with_ids(user)
    #used in _staff_fields for collection select of LastName, FirstName
    final_name_list = []
    user.lawfirm.staffings.each do |staff|
      final_name_list << [staff.full_name_last_first, staff.id]
    end
    final_name_list.sort
  end

  def self.import(file,user)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      if Staffing.find_by(email: row["Email"]) &&
        Staffing.find_by(email: row["Email"]).lawfirm_id == user.lawfirm_id
        staff = Staffing.find_by(email: row["Email"])
        staff.update_attributes(position: row["Position"],
                               first_name: row['First Name'],
                               middle_initial: row["Middle Name"],
                               last_name: row["Last Name"],
                               lawfirm_id: user.lawfirm_id)
        staff.save
      else
        Staffing.create(email: row["Email"],
                       position: row["Position"],
                       first_name: row['First Name'],
                       middle_initial: row["Middle Name"],
                       last_name: row["Last Name"],
                       lawfirm_id: user.lawfirm_id)
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
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
