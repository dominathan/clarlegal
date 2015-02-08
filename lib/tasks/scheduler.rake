desc "Heroku scheduler tasks"
task :send_reminder_emails => :environment do
  puts "Sending out email reminders for appointments."
  ReminderEmailWorker.perform_async
  puts "Emails sent!"
end
