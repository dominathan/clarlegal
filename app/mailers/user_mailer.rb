class UserMailer < ActionMailer::Base
  default from: "nathan.mh@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.signup_confirmation.subject
  #
  def signup_confirmation(user)
    @user = user.name
    mail to: user.email, subject: "Thank you for signing up with Clarlegal"
  end
end
