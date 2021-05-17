require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'sign_in_with_provider' do
    let(:oauth_data) { { provider: 'github', uid: 123, info: { email: 'test@email.com' } } }
    let(:oauth_data_without_email) { { provider: 'github', uid: 123, info: { city: 'mycity' } } }

    context 'provider does not transmit email ' do
      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data_without_email)
      end

      it 'redirect to new user registration path' do
        allow(User).to receive(:find_for_oauth).with(oauth_data_without_email)
        get :github
        expect(response).to redirect_to new_user_registration_path
      end
    end

    context 'provider transmit email' do
      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      end

      it 'finds user from oauth data' do
        expect(User).to receive(:find_for_oauth).with(oauth_data)
        get :github
      end

      context 'user exists' do
        let!(:user) { create(:user) }

        before do
          allow(User).to receive(:find_for_oauth).and_return(user)
          get :github
        end

        it 'login user' do
          expect(subject.current_user).to eq user
        end

        it 'redirects to root path' do
          expect(response).to redirect_to root_path
        end
      end

      context 'user does not exist' do
        before do
          allow(User).to receive(:find_for_oauth)
          get :github
        end

        it 'redirects to new_user_registration_url' do
          expect(response).to redirect_to new_user_registration_url
        end

        it 'does not login user' do
          expect(subject.current_user).to_not be
        end
      end
    end
  end
end
