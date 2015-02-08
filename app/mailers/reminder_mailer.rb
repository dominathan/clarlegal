require "sidekiq"

class ReminderMailer < ActionMailer::Base
  include Sidekiq::Worker
  default from: "noreply-clarlegal@clarlegal.com"

  def send_email_reminder(primary_emails_array)
    primary_emails_array.each do |primary_email_address|
      # mail to: primary_email_address, subject: ""
      # puts email_address
      logger.info { "#{primary_email_address}" }
    end
  end

end
