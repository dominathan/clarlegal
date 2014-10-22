class Timing < ActiveRecord::Base

  belongs_to :case

  #validates :case_id, presence: true
  validates :estimated_conclusion_expected, presence: true
  validates :estimated_conclusion_fast, presence: true
  validates :estimated_conclusion_slow, presence: true

  private

    def self.month_minus_one
      #using gem 'whenever', subtract 1 month at the beginning of every month from all cases
      #every 1.month, :at => "beginning of the month at 3am"
      @cases = Case.all
      @cases.each do |ca|
        if ca.timing
          @timing = ca.timing.all
          @timing.each do |ca_ti|
            if ca_ti.estimated_conclusion_slow
              ca_ti.estimated_conclusion_slow = ca_ti.estimated_conclusion_slow - 1
            end
            if ca_ti.estimated_conclusion_expected
              ca_ti.estimated_conclusion_expected = ca_ti.estimated_conclusion_expected - 1
            end
            if ca_ti.estimated_conclusion_fast
              ca_ti.estimated_conclusion_fast = ca_ti.estimated_conclusion_fast - 1
            end
            ca_ti.save
          end
        else
          next
        end
      end
    end


end
