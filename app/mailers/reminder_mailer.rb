class ReminderMailer < ActionMailer::Base
  default from: "noreply-clarlegal@clarlegal.com"

  def send_email_reminder(case_id)
    @case = Case.find_by_id(case_id)

    puts "Case id: #{@case.id}. Primary email: #{@case.primary_email}"
  end

end
