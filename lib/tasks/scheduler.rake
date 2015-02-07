desc "Heroku scheduler tasks"
task :email_appointments_reminder => :environment do
  puts "Sending out email reminders for appointments."
  Case.email_reminder
  puts "Emails sent!"
end
