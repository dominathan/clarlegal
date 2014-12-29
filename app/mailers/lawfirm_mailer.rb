class LawfirmMailer < ActionMailer::Base
  default from: "noreply-clarlegal@clarlegal.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.lawfirm_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    @lawfirm = user.lawfirm
    mail to: user.email, subject: "Password Reset Instructions"
  end
end
