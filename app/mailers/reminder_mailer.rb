require "sidekiq"

class ReminderMailer < ActionMailer::Base
  include Sidekiq::Worker
  default from: "noreply-clarlegal@clarlegal.com"

  def reminder_email(email_array)
    email_array.each do |email_address|
      # mail to: email_address, subject: "Account Activation"
      puts email_address
    end
  end

  def perform(email_array)
    reminder_email(email_array)
  end
end
