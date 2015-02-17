class SubscriptionMailer < ActionMailer::Base
  default from: "noreply@clarlegal.com"

  def demo_request(user)
    mail to: user, subject: "ClarLegal Demo", bcc: "nathan.hall@clarlegal.com"
  end

end
