class Closeout < ActiveRecord::Base
  belongs_to :case

  validates :case_id, presence: true

  def self.close_case(case_name)
    case_name.open = 0
    case_name.save
    #do not double count actual amounts when case is closed
    if case_name.fixed_fees.any?
      FixedFee.remove_expected_actual(case_name)
    end
  end

  def self.open_case(case_name)
    case_name.open = 1
    case_name.save
  end


end
