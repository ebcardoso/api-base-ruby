class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.smtp_username
  layout "mailer"

  def token_forgot_password(email, token)
    @token = token
    @email = email
    mail(
      from: "#{Rails.application.secrets.app_name} <#{Rails.application.secrets.smtp_username}>", 
      to: @email, 
      subject: 'Forgot Password Token'
    )
  end
end
