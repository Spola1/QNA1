require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user)     { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'Authorized user' do
      before { login(user) }

      it 'subscribes the user to question' do
        expect { post :create, params: { question_id: question.id }, format: :js }.to change(user.subscriptions, :count).by(1)
      end

      it 'assigns subscription to current user' do
        post :create, params: { question_id: question.id }, format: :js
        expect(assigns(:subscription).user).to eq user
      end

      it 'renders create view' do
        post :create, params: { question_id: question.id }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'Unauthorized user' do
      it 'do not subscribes the user to question' do
        expect { post :create, params: { question_id: question }, format: :js }.to_not change(user.subscriptions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, question: question, user: user) }
    let!(:another_user) { create(:user) }

    context 'Authorized subscribed user' do
      before do
        login(user)
      end

      it 'unsubscribes the user from question' do
        expect { delete :destroy, params: { id: subscription }, format: :js }.to change(user.subscriptions, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: subscription }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Authorized not subscribed user' do
      before do
        login(another_user)
      end

      it 'tries to delete another user subscription' do
        expect { delete :destroy, params: { id: subscription }, format: :js }.to raise_exception ActiveRecord::RecordNotFound
      end
    end

    context 'Unauthorized user' do
      it 'do not unsubscribes the user to question' do
        expect { delete :destroy, params: { id: subscription }, format: :js }.to_not change(user.subscriptions, :count)
      end
    end
  end
end
