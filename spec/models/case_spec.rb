require 'spec_helper'

include SpecHelper

describe Case do
  before {
    judge_list = ["Houston L. Brown","Donald Blankenship","Joseph Boohaker","Elisabeth French", "Helen Shores Lee", "Robert Vance"]

    10.times do |n|
      Case.create!(
          client_id: Random.rand(1..20),
          practicegroup_id: Random.rand(1..20),
          primary_email: Faker::Internet.email,
          updated_at: 1.month.ago
        )

      Fee.create!(
          case_id: n,
          high_estimate: 10,
          medium_estimate: 5,
          low_estimate: 1,
          updated_at: 1.month.ago
        )

      Timing.create!(
          case_id: n,
          estimated_conclusion_fast: 1.month.ago + 1.day,
          estimated_conclusion_expected: 1.month.ago + 5.days,
          estimated_conclusion_slow: 1.month.ago + 1.month,
          updated_at: 1.month.ago
        )
    end

    3.times do |n|
      Case.create!(
          client_id: Random.rand(1..20),
          practicegroup_id: Random.rand(1..20),
          primary_email: Faker::Internet.email,
          updated_at: Time.now
        )

      Fee.create!(
          case_id: n,
          high_estimate: 10,
          medium_estimate: 5,
          low_estimate: 1,
          updated_at: Time.now
        )

      Timing.create!(
          case_id: n,
          estimated_conclusion_fast: Time.now + 1.day,
          estimated_conclusion_expected: Time.now + 5.days,
          estimated_conclusion_slow: Time.now + 1.month,
          updated_at: Time.now
        )
    end
  }


  describe '#get_old_case_ids' do
    it 'only returns primary email addresses of cases that have not been updated in at least 1 month (default frequency)' do
      @results = Case.get_old_case_ids(1.month.ago)
      @results.size.should eq(10)
    end
  end

  describe '#self.reminder_email' do
    it 'retrieves case ids of all users' do
      Case.reminder_email.size.should eq(13)
    end

    it 'sends an email to each case primary email address' do
      expect(Delayed::Job.count).to eq(0)

      Case.reminder_email

      expect(Delayed::Job.count).to eq(13)

      expect(Delayed::Worker.new.work_off).to  eq([13,0]) # Returns [successes, failures]
    end
  end
end
