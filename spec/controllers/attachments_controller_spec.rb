require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:user)     { create(:user) }
  let!(:question) { create(:question_with_file) }

  describe 'DELETE #destroy' do
    context 'Authorized author' do
      before { login(question.user) }

      it 'deletes the file' do
        expect do
          delete :destroy, params: { id: question.files.first.id }, format: :js
        end.to change(question.files, :count).by(-1)
      end
    end

    context 'Authorized not author user' do
      before { login(user) }

      it 'can not deletes the file' do
        expect do
          delete :destroy, params: { id: question.files.first.id }, format: :js
        end.to_not change(question.files, :count)
      end
    end

    context 'Unauthorized user' do
      it 'can not deletes the file' do
        expect do
          delete :destroy, params: { id: question.files.first.id }, format: :js
        end.to_not change(question.files, :count)
      end
    end
  end
end
