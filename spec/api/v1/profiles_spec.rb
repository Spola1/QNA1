require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) {{"ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method)   { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it_behaves_like 'providable public fields' do
          let(:fields_list)     { %w[id email admin created_at updated_at] }
          let(:object)          { me }
          let(:object_response) { json['user'] }
        end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/all_but_me' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:users)        { create_list(:user, 3) }
      let(:me)           { users.last }
      let(:user)         { users.first }
      let(:user_response){ json['users'].first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of users' do
        expect(json['users'].size).to eq 2
      end

      it 'does not returns me' do
        expect(json['users'].map{:user['id']}).to_not include(me.id)
      end

      it_behaves_like 'providable public fields' do
        let(:fields_list)     { %w[id email admin created_at updated_at] }
        let(:object)          { user }
        let(:object_response) { user_response }
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(user_response).to_not have_key(attr)
        end
      end
    end
  end
end
