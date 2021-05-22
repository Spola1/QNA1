class SubscriptionsMailer < ApplicationMailer
  def send_notification(user, answer)
    @answer = answer
    mail to: user.email, subject: "Answer notification"
  end
end
