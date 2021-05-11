require 'rails_helper'

shared_examples 'voted_question' do
  let!(:user)         { create(:user) }
  let!(:question)     { create(:question) }
  let!(:voted)        { create(:vote, user: user, votable: question, value: 1) }
  let(:response_up) {}

  before { login(user) }

  describe 'PATCH#vote_up' do
    it 'responds with success' do
      patch :vote_up, params: { id: question }, format: :json
      # specify{expect(response).to have_http_status(:success)}
      expect(response.body).to eq "{\"id\":#{question.id},\"rating\":#{question.rating},\"voted\":#{user.voted?(question)}}"
    end
  end

  describe 'PATCH#vote_down' do
    it 'responds with success' do
      patch :vote_down, params: { id: question }, format: :json
      # expect(response).to have_http_status(:success)
      expect(response.body).to eq "{\"id\":#{question.id},\"rating\":#{question.rating},\"voted\":#{user.voted?(question)}}"
    end
  end

  describe 'PATCH#vote_cancel' do
    it 'responds with success' do
      patch :vote_cancel, params: { id: question }, format: :json
      # expect(response).to have_http_status(:success)
      expect(response.body).to eq "{\"id\":#{question.id},\"rating\":#{question.rating},\"voted\":#{user.voted?(question)}}"
    end
  end
end

shared_examples 'voted_answer' do
  let!(:user)   { create(:user) }
  let!(:answer) { create(:answer) }
  let!(:voted)  { create(:vote, user: user, votable: answer, value: 1) }

  before { login(user) }

  describe 'PATCH#vote_up' do
    it 'responds with success' do
      patch :vote_up, params: { id: answer }, format: :json
      # expect(response).to have_http_status(:success)
      expect(response.body).to eq "{\"id\":#{answer.id},\"rating\":#{answer.rating},\"voted\":#{user.voted?(answer)}}"
    end
  end

  describe 'PATCH#vote_down' do
    it 'responds with success' do
      patch :vote_down, params: { id: answer }, format: :json
      # expect(response).to have_http_status(:success)
      expect(response.body).to eq "{\"id\":#{answer.id},\"rating\":#{answer.rating},\"voted\":#{user.voted?(answer)}}"
    end
  end

  describe 'PATCH#vote_cancel' do
    it 'responds with success' do
      patch :vote_cancel, params: { id: answer }, format: :json
      # expect(response).to have_http_status(:success)
      expect(response.body).to eq "{\"id\":#{answer.id},\"rating\":#{answer.rating},\"voted\":#{user.voted?(answer)}}"
    end
  end
end
