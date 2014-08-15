class Case < ActiveRecord::Base
  belongs_to :lawfirm
  belongs_to :client
  belongs_to :user

  has_many :fee
  has_many :fees
  accepts_nested_attributes_for :fees

  has_many :staff
  has_many :staffs
  accepts_nested_attributes_for :staffs, :reject_if => :all_blank
  has_many :timing
  has_many :timings
  accepts_nested_attributes_for :timings
  has_many :originations
  accepts_nested_attributes_for :originations
  has_many :venues
  accepts_nested_attributes_for :venues
  has_many :checks
  accepts_nested_attributes_for :checks
  has_many :closeouts


  validates :client_id, presence: true

  attr_accessor :new_court, :new_judge, :new_opposing_attorney,
                :new_type_of_matter, :new_practice_group




  def self.lead_attorney(case_name)
    @lead_att = nil
    case_name.staff.each do |stf|
      stf.position == "Responsible Attorney" ? @lead_att = stf.name : next
    end
    @lead_att
  end


end
