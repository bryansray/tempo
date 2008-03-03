class UserNotifier < ActionMailer::Base
  def forgot_password(user)
    setup_email(user)
    @subject += "Password Change Request"
    @body[:url] = "http://localhost:3000/reset_password/#{user.password_reset_code}"
  end
  
  protected
  def setup_email(user)
    @recipients = "#{user.email}"
    @from = "tempo@datacert.com"
    @subject = "Tempo - "
    @sent_on = Time.now
    @body[:user] = user
  end
end