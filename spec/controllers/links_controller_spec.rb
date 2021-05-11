require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:user)     { create(:user) }
  let!(:question) { create(:question_with_links) }

  describe 'DELETE #destroy' do
    context 'Authorized author' do
      before { login(question.user) }

      it 'deletes the link' do
        expect do
          delete :destroy, params: { id: question.links.first.id }, format: :js
        end.to change(question.links, :count).by(-1)
      end
    end

    context 'Authorized not author user' do
      before { login(user) }

      it 'can not deletes the link' do
        expect do
          delete :destroy, params: { id: question.links.first.id }, format: :js
        end.to_not change(question.links, :count)
      end
    end

    context 'Unauthorized user' do
      it 'can not deletes the link' do
        expect do
          delete :destroy, params: { id: question.links.first.id }, format: :js
        end.to_not change(question.links, :count)
      end
    end
  end
end
