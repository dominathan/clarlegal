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
  has_many :closeouts, inverse_of: :case
  accepts_nested_attributes_for :closeouts
  has_many :matters
  accepts_nested_attributes_for :matters, :reject_if => :all_blank
  has_many :related_cases
  accepts_nested_attributes_for :related_cases, :reject_if => :all_blank

  has_many :fixed_fees


  validates :client_id, presence: true
  validates :practicegroup_id, presence: true

  attr_accessor :new_court, :new_judge, :new_opposing_attorney,
                :new_type_of_matter, :new_practice_group, :new_referral_source

  def self.lead_attorney(case_name)
    @lead_att = nil
    case_name.staff.each do |stf|
      if stf.position == "Responsible Attorney" || stf.position == "Lead Attorney" ||
      stf.position == "Billing Attorney" || stf.position == "Billing Partner" ||
      stf.position == "Responsible Partner" || stf.position == "Lead Partner"
        @lead_att = Staffing.find_by(id: stf.staffing_id).full_name
      else
        @lead_at = "Must Select Lead Attorney"
      end
    end
    @lead_att
  end

  def self.client_id_list(user)
    return user.clients.ids
  end

  def self.client_id_list_of_lawfirm(user)
    return user.lawfirm.client_ids
  end

  def self.get_old_case_ids(date_since_last_update=1.month.ago)
    # Case.select { |ca|
    #                 ca.updated_at <= date_since_last_update &&
    #                 ca.fees.last.updated_at <= date_since_last_update &&
    #                 ca.timings.last.updated_at <= date_since_last_update }
    #     .collect(&:id)

    Case.select { |ca|
                      ca.updated_at <= date_since_last_update }
          .collect(&:id)

  end

  def self.reminder_email
    Case.pluck(:id).each do |case_id|
      ReminderMailer.delay.send_email_reminder(case_id)
    end
  end

end
