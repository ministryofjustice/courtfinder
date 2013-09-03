class NotificationsMailer < ActionMailer::Base

  default to: ENV['FEEDBACK_EMAIL_RECEIVER'],
          from: ENV['SMTP_USERNAME']

  def new_message(message)
    @message = message
    mail(:subject => "New feedback")
  end

end
