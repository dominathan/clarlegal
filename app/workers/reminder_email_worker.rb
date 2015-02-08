class ReminderEmailWorker
  include Sidekiq::Worker

  # Disable Sidekiq default retry option to prevent
  # users potentially receiving multiple emails
  # if an error causes this worker to retry
  sidekiq_options retry: false

  def get_primary_emails
    @cases = Case.where(:updated_at => 6.months.ago..Time.now)
    @primary_emails_array = @cases.map do |c|
      c.primary_email
    end

    return @primary_emails_array
  end

  def perform
    ReminderMailer.send_email_reminder(self.get_primary_emails)
  end
end
