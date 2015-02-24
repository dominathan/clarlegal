class Closeout < ActiveRecord::Base
  belongs_to :case, inverse_of: :closeouts

  validates_presence_of :case

  #validates :total_recovery, presence: true
  #validates :total_gross_fee_received, presence: true
  #validates :total_out_of_pocket_expenses, presence: true
  #validates :referring_fees_paid, presence: true
  validates :total_fee_received, presence: true
  validates :date_fee_received, presence: true

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
