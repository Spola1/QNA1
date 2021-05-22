require 'rails_helper'

#INDEX

describe 'Answers API', type: :request do
  let(:headers) {{"ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/questions/:question_id/answers' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token)    { create(:access_token)}
      let!(:answers)        { create_list(:answer, 3, question: question) }
      let(:answer)          { answers.first }
      let(:answer_response) { json['answers'].first }

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['answers'].size).to eq 3
      end

      it_behaves_like 'providable public fields' do
        let(:fields_list)     { %w[id body created_at updated_at] }
        let(:object)          { answer }
        let(:object_response) { answer_response }
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq answer.user.id
      end
    end
  end

  #SHOW

  describe 'GET /api/v1/answers/:id' do
    let!(:answer)         { create(:answer_with_file) }
    let!(:links)          { create_list(:link, 3,  linkable: answer)}
    let!(:comments)       { create_list(:comment, 3,  commentable: answer)}
    let(:answer_response) { json['answer'] }
    let(:api_path)        { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token)}

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it_behaves_like 'providable public fields' do
        let(:fields_list)     { %w[id body created_at updated_at] }
        let(:object)          { answer }
        let(:object_response) { json['answer'] }
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq answer.user.id
      end

      describe 'links' do
        it_behaves_like 'providable public fields' do
          let(:fields_list)     { %w[id name url created_at updated_at] }
          let(:object)          { links.first }
          let(:object_response) { json['answer']['links'].first }
        end
      end

      it 'returns list of links' do
        expect(json['answer']['links'].size).to eq 3
      end

      describe 'comments' do
        it_behaves_like 'providable public fields' do
          let(:fields_list)     { %w[id user_id body created_at updated_at] }
          let(:object)          { comments.first }
          let(:object_response) { json['answer']['comments'].first }
        end
      end

      it 'returns list of links' do
        expect(json['answer']['comments'].size).to eq 3
      end

      it 'contains file link' do
        expect(json['answer']['files'].first).to eq Rails.application.routes.url_helpers.rails_blob_path(answer.files.first, only_path: true)
      end
    end
  end

  #CREATE

  describe 'POST /api/v1/questions/question_id/answers' do
    let!(:question){ create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}

      context 'with valid attributes' do
        it 'create new Answer' do
          expect do
            post api_path, params: { answer: attributes_for(:answer), access_token: access_token.token}, headers: headers
          end.to change(Answer, :count).by(1)
        end

        before { post api_path, params: { answer: { body: 'new body'}, access_token: access_token.token}, headers: headers}

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returns new answer' do
          expect(json['answer']['body']).to eq 'new body'
        end

        it 'contains user object' do
          expect(json['answer']['user']['id']).to eq access_token.resource_owner_id
        end
      end

      context 'with invalid attributes' do
        it 'does not create new Answer' do
          expect do
            post api_path, params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token}, headers: headers
          end.to_not change(Question, :count)
        end

        before { post api_path, params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token}, headers: headers}

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end

        it 'returns errors' do
          expect(json['errors']).to be
        end
      end
    end
  end

  #UPDATE

  describe 'PATCH /api/v1/questions/:id' do
    let(:user)     { create(:user)}
    let(:answer)   { create(:answer, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized author' do
      let(:access_token) {create(:access_token, resource_owner_id: user.id )}

      context 'with valid attributes' do
        before { patch api_path, params: {answer: { body: 'edited body'}, access_token: access_token.token}, headers: headers}

        it 'updates the answer' do
          answer.reload

          expect(answer.body).to eq 'edited body'
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returns edited answer json' do
          expect(json['answer']['body']).to eq 'edited body'
        end

        it 'contains user object' do
          expect(json['answer']['user']['id']).to eq answer.user.id
        end
      end

      context 'with invalid attributes' do
        let(:old_body)  {answer.body}

        before { patch api_path, params: {answer: attributes_for(:answer, :invalid), access_token: access_token.token}, headers: headers}

        it 'does not update a answer' do
          answer.reload
          expect(answer.body).to eq old_body
        end

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end

        it 'returns errors' do
          expect(json['errors']).to be
        end
      end

      context 'authorized not author' do
        let(:another_user)      { create(:user)}
        let(:another_answer)    { create(:answer, user: another_user) }
        let(:another_api_path)  { "/api/v1/answers/#{another_answer.id}" }
        let(:another_old_body)  { another_answer.body}

        before { patch another_api_path, params: {answer: { body: 'edited body'}, access_token: access_token.token}, headers: headers}

        it 'does not update the answer' do
          another_answer.reload
          expect(another_answer.body).to eq another_old_body
        end
      end
    end
  end

  #DESTROY 

  describe 'DELETE /api/v1/answers/:id' do
    let!(:user)       { create(:user)}
    let!(:answer)     { create(:answer, user: user) }
    let!(:api_path)   { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized author' do
      let(:access_token) {create(:access_token, resource_owner_id: user.id )}

      it 'deletes the answer' do
        expect do
          delete api_path, params: { access_token: access_token.token}, headers: headers
        end.to change(Answer, :count).by(-1)
      end

      it 'returns 200 status' do
        delete api_path, params: { access_token: access_token.token}, headers: headers
        expect(response).to be_successful
      end

      it 'returns deleted answer json' do
        delete api_path, params: { access_token: access_token.token}, headers: headers
        %w[id body created_at updated_at].each do |attr|
          expect(json['answer'][attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        delete api_path, params: { access_token: access_token.token}, headers: headers
        expect(json['answer']['user']['id']).to eq answer.user.id
      end

      context 'authorized not author' do
        let!(:another_user)     { create(:user)}
        let!(:another_answer)   { create(:answer, user: another_user) }
        let(:another_api_path)  { "/api/v1/answers/#{another_answer.id}" }

        it 'does non deletes the answer' do
          expect do
            delete another_api_path, params: { access_token: access_token.token}, headers: headers
          end.to_not change(Answer, :count)
        end
      end
    end
  end
end
