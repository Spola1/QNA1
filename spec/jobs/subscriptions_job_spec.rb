require 'rails_helper'

RSpec.describe SubscriptionsJob, type: :job do
  let(:answer)  { create(:answer) }
  let(:service) { double('SubscriptionsService') }

  before do
    allow(SubscriptionsService).to receive(:new).and_return(service)
  end
  it 'calls SubscriptionsService#send_subscriptions' do
    expect(service).to receive(:send_subscriptions).with(answer)
    SubscriptionsJob.perform_now(answer)
  end
end
