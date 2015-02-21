class ReminderMailer < ActionMailer::Base
  default from: "noreply-clarlegal@clarlegal.com"

  def default_reminder(case_id)
    @case = Case.find_by_id(case_id)

    mail to: @case.primary_email, subject: "Reminder: Please Update Your Case"
  end

end
