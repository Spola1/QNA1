require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions)   { create_list(:question, 3) }
      let(:question)     { questions.first }
      let(:question_response) { json['questions'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 3
      end

      it_behaves_like 'providable public fields' do
        let(:fields_list)     { %w[id title body created_at updated_at] }
        let(:object)          { question }
        let(:object_response) { question_response }
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question)         { create(:question_with_file) }
    let!(:links)            { create_list(:link, 3, linkable: question) }
    let!(:comments)         { create_list(:comment, 3, commentable: question) }
    let(:question_response) { json['question'] }
    let(:api_path)          { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it_behaves_like 'providable public fields' do
        let(:fields_list)     { %w[id title body created_at updated_at] }
        let(:object)          { question }
        let(:object_response) { json['question'] }
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      describe 'links' do
        it_behaves_like 'providable public fields' do
          let(:fields_list)     { %w[id name url created_at updated_at] }
          let(:object)          { links.first }
          let(:object_response) { json['question']['links'].first }
        end
      end

      it 'returns list of links' do
        expect(json['question']['links'].size).to eq 3
      end

      describe 'comments' do
        it_behaves_like 'providable public fields' do
          let(:fields_list)     { %w[id user_id body created_at updated_at] }
          let(:object)          { comments.first }
          let(:object_response) { json['question']['comments'].first }
        end
      end

      it 'returns list of links' do
        expect(json['question']['comments'].size).to eq 3
      end

      it 'contains file link' do
        # include Rails.application.routes.url_helpers
        expect(json['question']['files'].first).to eq Rails.application.routes.url_helpers.rails_blob_path(question.files.first,
                                                                                                           only_path: true)
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid attributes' do
        it 'create new Question' do
          expect do
            post api_path, params: { question: attributes_for(:question), access_token: access_token.token }, headers: headers
          end.to change(Question, :count).by(1)
        end

        before do
          post api_path, params: { question: { title: 'new title', body: 'new body' }, access_token: access_token.token },
                         headers: headers
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returns new question' do
          expect(json['question']['title']).to eq 'new title'
          expect(json['question']['body']).to eq 'new body'
        end

        it 'contains user object' do
          expect(json['question']['user']['id']).to eq access_token.resource_owner_id
        end
      end

      context 'with invalid attributes' do
        it 'does not create new Question' do
          expect do
            post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token },
                           headers: headers
          end.to_not change(Question, :count)
        end

        before do
          post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token },
                         headers: headers
        end

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end

        it 'returns errors' do
          expect(json['errors']).to be
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user)       { create(:user) }
    let(:question)   { create(:question, user: user) }
    let(:api_path)   { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized author' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        before do
          patch api_path, params: { question: { title: 'edited title', body: 'edited body' }, access_token: access_token.token },
                          headers: headers
        end

        it 'updates the question' do
          question.reload

          expect(question.title).to eq 'edited title'
          expect(question.body).to eq 'edited body'
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returns edited question json' do
          expect(json['question']['title']).to eq 'edited title'
          expect(json['question']['body']).to eq 'edited body'
        end

        it 'contains user object' do
          expect(json['question']['user']['id']).to eq question.user.id
        end
      end

      context 'with invalid attributes' do
        let(:old_title) { question.title }
        let(:old_body)  { question.body }

        before do
          patch api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token },
                          headers: headers
        end

        it 'does not update a question' do
          question.reload

          expect(question.title).to eq old_title
          expect(question.body).to eq old_body
        end

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end

        it 'returns errors' do
          expect(json['errors']).to be
        end
      end

      context 'authorized not author' do
        let(:another_user)      { create(:user) }
        let(:another_question)  { create(:question, user: another_user) }
        let(:another_api_path)  { "/api/v1/questions/#{another_question.id}" }
        let(:another_old_title) { another_question.title }
        let(:another_old_body)  { another_question.body }

        before do
          patch another_api_path, params: { question: { title: 'edited title', body: 'edited body' }, access_token: access_token.token },
                                  headers: headers
        end

        it 'does not update a question' do
          another_question.reload

          expect(another_question.title).to eq another_old_title
          expect(another_question.body).to eq another_old_body
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:user)       { create(:user) }
    let!(:question)   { create(:question, user: user) }
    let!(:api_path)   { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized author' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it 'deletes the question' do
        expect do
          delete api_path, params: { access_token: access_token.token }, headers: headers
        end.to change(Question, :count).by(-1)
      end

      it 'returns 200 status' do
        delete api_path, params: { access_token: access_token.token }, headers: headers
        expect(response).to be_successful
      end

      it 'returns deleted question json' do
        delete api_path, params: { access_token: access_token.token }, headers: headers
        %w[id title body created_at updated_at].each do |attr|
          expect(json['question'][attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        delete api_path, params: { access_token: access_token.token }, headers: headers
        expect(json['question']['user']['id']).to eq question.user.id
      end

      context 'authorized not author' do
        let!(:another_user)     { create(:user) }
        let!(:another_question) { create(:question, user: another_user) }
        let(:another_api_path)  { "/api/v1/questions/#{another_question.id}" }

        it 'does non deletes the question' do
          expect do
            delete another_api_path, params: { access_token: access_token.token }, headers: headers
          end.to_not change(Question, :count)
        end
      end
    end
  end
end
