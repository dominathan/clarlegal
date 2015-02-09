require 'spec_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

include SpecHelper

describe ReminderEmailWorker do
  before {
    judge_list = ["Houston L. Brown","Donald Blankenship","Joseph Boohaker","Elisabeth French", "Helen Shores Lee", "Robert Vance"]

    10.times do
      plaintiff = Faker::Name.name
      defendant = Faker::Name.name
      opposing_attorney = Faker::Name.name
      Case.create!(
          client_id: Random.rand(1..20),
          practicegroup_id: Random.rand(1..20),
          primary_email: Faker::Internet.email,
          updated_at: rand_time(1.year.ago, 6.months.ago),
        )
    end

    5.times do
      plaintiff = Faker::Name.name
      defendant = Faker::Name.name
      opposing_attorney = Faker::Name.name
      Case.create!(
          client_id: Random.rand(1..20),
          practicegroup_id: Random.rand(1..20),
          primary_email: Faker::Internet.email,
          updated_at: rand_time(5.months.ago),
        )
    end
  }


  describe '#get_primary_emails' do
    it 'only returns primary email addresses of cases that have not been updated in at least 6 months' do
      @primary_emails_array = ReminderEmailWorker.new.get_primary_emails
      @primary_emails_array.size.should eq(10)
    end
  end

  describe '#perform' do
    before {
      Sidekiq::Worker.clear_all
    }

    it 'has no jobs queued initially' do
      ReminderEmailWorker.jobs.size.should eq(0)
    end

    it 'adds a job to the queue' do
      ReminderEmailWorker.perform_async
      ReminderEmailWorker.jobs.size.should eq(1)
    end
  end
end
