class SubscriptionsJob < ApplicationJob
  queue_as :default

  def perform(object)
    SubscriptionsService.new.send_subscriptions(object)
  end
end
