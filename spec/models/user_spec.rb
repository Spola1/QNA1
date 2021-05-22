require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:question) { create(:question) }
  let(:user)      { create(:user) }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:awards) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe '.find_for_oauth' do
    let!(:user)   { create(:user) }
    let(:auth)    { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#author?' do
    context 'true if author of object' do
      it { expect(question.user).to be_author(question) }
    end

    context 'false if not author of object' do
      it { expect(user).to_not be_author(question) }
    end
  end

  describe '.new_with_session' do
    let!(:session)  { { "omniauth" => { provider: 'facebook', uid: '123456' } } }
    let(:result)    { User.new_with_session({}, session) }

    it 'creates new user' do
      expect(subject).to be_a_new(User)
    end

    it 'adds password for user' do
      expect(result.password).to_not eq ''
      expect(result.password_confirmation).to_not eq ''
    end
  end

  describe '#subscribed?' do
    let!(:subscription) {create(:subscription, question: question, user: user)}
    let!(:another_user) {create(:user) }

    context 'true if subscribed to question' do
      it { expect(user).to be_subscribed(question) }
    end

    context 'false if not author of object' do
      it { expect(another_user).to_not be_subscribed(question) }
    end
  end
end
