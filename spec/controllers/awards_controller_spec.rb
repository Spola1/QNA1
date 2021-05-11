require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let!(:user)     { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:award)    { create(:award, question: question, user: user) }

  describe 'GET#index' do
    before do
      login(question.user)
      get :index
    end

    it 'assigns awards equal to user awards' do
      expect(assigns(:awards)).to eq user.awards
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
