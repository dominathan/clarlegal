desc "Heroku scheduler tasks"
task :send_reminder_emails => :environment do
  puts "Sending out email reminders for appointments."
  # ReminderEmailWorker.perform_async


  # def self.prim_emails_and_case_ids(var)
  #   email_and_ids = []
  #   var.each do |id|
  #     email_and_ids << [Case.find(id).primary_email, id]
  #   end
  #   vals = email_and_ids.group_by { |item| item[0] }
  #   keys = vals.keys
  #   keys.each do |key|
  #     vals[key] = vals[key].map { |item| item[1] }
  #   end
  #   vals
  # end
  Case.reminder_email
  puts "Emails sent!"
end
