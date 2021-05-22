class SubscriptionsService
  def send_subscriptions(answer)
    subscriptions = answer.question.subscriptions
    subscriptions.each do |subscription|
      SubscriptionsMailer.send_notification(subscription.user, answer).deliver_later
    end
  end
end
