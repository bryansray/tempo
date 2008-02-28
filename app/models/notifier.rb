class Notifier < ActionMailer::Base
  def forgot_password(user)
    recipients user.email
    from "no-reply-tempo@datacert.com"
    subject "You have requested a password change"
    
    body :url => "http://localhost:3000/reset_password/#{user.password_reset_code}"
  end
end
