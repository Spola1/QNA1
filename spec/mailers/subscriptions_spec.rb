require "rails_helper"

RSpec.describe SubscriptionsMailer, type: :mailer do
  describe "send_notification" do
    let!(:question) { create(:question) }
    let!(:answer)   { create(:answer, question: question) }
    let!(:user)     { create(:user) }
    let(:mail)      { SubscriptionsMailer.send_notification(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Answer notification")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to have_content("new Answer to subscribed Question:")
    end
  end
end
