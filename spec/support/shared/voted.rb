shared_examples_for 'voted' do
  let!(:vote) { create(:vote, user: user, votable: object, value: 1) }

  before { login(user) }

  describe 'PATCH#vote_up' do
    it 'responds with success' do
      patch :vote_up, params: { id: object }, format: :json
      expect(response).to have_http_status(:success)
      expect(response.body).to eq "{\"id\":#{object.id},\"rating\":#{object.rating},\"voted\":#{user.voted?(object)}}"
    end
  end

  describe 'PATCH#vote_down' do
    it 'responds with success' do
      patch :vote_down, params: { id: object }, format: :json
      expect(response).to have_http_status(:success)
      expect(response.body).to eq "{\"id\":#{object.id},\"rating\":#{object.rating},\"voted\":#{user.voted?(object)}}"
    end
  end

  describe 'PATCH#vote_cancel' do
    it 'responds with success' do
      patch :vote_cancel, params: { id: object }, format: :json
      expect(response).to have_http_status(:success)
      expect(response.body).to eq "{\"id\":#{object.id},\"rating\":#{object.rating},\"voted\":#{user.voted?(object)}}"
    end
  end
end
