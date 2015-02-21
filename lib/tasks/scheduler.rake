desc "Heroku scheduler tasks"
task :send_reminder_emails => :environment do
  puts "Sending out email reminders for appointments."

  Case.reminder_email

  puts "Emails sent!"
end
