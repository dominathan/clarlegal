class SubscriptionMailer < ActionMailer::Base
  default from: "noreply@clarlegal.com"

  def demo_request(user)
    @user = user
    mail to: user.email, subject: "ClarLegal Demo", bcc: "nathan.hall@clarlegal.com"
  end

end
