class FixedFee < ActiveRecord::Base
  belongs_to :case

  #create db entry on new case
  def self.initial_fixed_fee(newcase)
    fixed_fee = FixedFee.new
    fixed_fee.case_id = newcase.id
    fixed_fee.expected_remaining = newcase.fees.first.medium_estimate
    fixed_fee.actual_earned = 0
    #make monthly converstion rate based on expected conclusion date and medium estimate
    current_date = Date.today
    expected_months_remaining = ((newcase.timings.last.estimated_conclusion_expected - current_date).to_f / (365/12).to_f).round
    fixed_fee.conversion_rate = (fixed_fee.expected_remaining / expected_months_remaining).round(2)
    fixed_fee.save
  end

  #Call method in cron to move Expected amounts to Actual based on conversion rate
  def self.monthly_fixed_fee_adjustment
    if FixedFee.any?
      case_list = FixedFee.all.collect(&:case_id).uniq
      case_list.each do |ca|
        monthly_update = FixedFee.where(case_id: ca).order(:updated_at).last
        unless monthly_update.expected_remaining <= 0
          FixedFee.create!(case_id: monthly_update.case_id,
                           expected_remaining: monthly_update.expected_remaining - monthly_update.conversion_rate,
                           actual_earned: monthly_update.actual_earned + monthly_update.conversion_rate,
                           conversion_rate: monthly_update.conversion_rate)
        end
      end
    end
  end

  #do not double count FixedFee amounts when case is closed... 0 out database entries
  def self.remove_expected_actual(case_name)
    fixed_fee = FixedFee.create!(case_id: case_name.id,
                      expected_remaining: 0,
                      conversion_rate: 0,
                      actual_earned: 0)
    fixed_fee.save
  end

end
