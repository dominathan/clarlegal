class ReminderEmailWorker
  include Sidekiq::Worker

  # Disable Sidekiq default retry option to prevent
  # users potentially receiving multiple emails
  # if an error causes this worker to retry
  sidekiq_options retry: false

  def get_primary_emails
    # Why use .pluck? see http://rubyinrails.com/2014/06/rails-pluck-vs-select-map-collect/
    return Case.where("updated_at < :default", {:default => 6.months.ago}).pluck(:primary_email)
  end

  def perform
    ReminderMailer.send_email_reminder(self.get_primary_emails)
  end
end
