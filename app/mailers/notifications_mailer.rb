class NotificationsMailer < ActionMailer::Base

  default to: ENV['FEEDBACK_EMAIL_RECEIVER'], from: "no-reply@courttribunalfinder.service.gov.uk"

  def new_message(message)
    @message = message
    mail(subject: "New feedback from courtfinder for: #{message['referrer']}")
  end

end
