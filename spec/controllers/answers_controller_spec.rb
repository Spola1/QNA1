require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user)     { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer)   { create(:answer, question: question) }
  let(:old_body)  { answer.body }
  let(:question_w) { create(:question, :with_best_answer, user: user) }

  it_behaves_like 'voted' do
    let(:object) { answer }
    let(:user)   { answer.user }
  end

  describe 'Get #edit' do
    it 'renders edit view for authorized author' do
      login(answer.user)
      get :edit, params: { id: answer }
      expect(response).to render_template :edit
    end

    it 'renders sign in view for unauthorized user' do
      get :edit, params: { id: answer }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'PATCH #best' do
    context 'Authorized question author' do
      it 'saves best answer in database' do
        login(question.user)
        patch :best, params: { id: answer }, format: :js

        answer.reload
        expect(answer.question.best_answer).to eq answer
      end
    end

    context 'Authorized user' do
      it 'not saves best answer in database' do
        login(user)
        patch :best, params: { id: answer }, format: :js

        answer.reload
        expect(answer.question.best_answer).to_not eq answer
      end
    end

    context 'Unauthorized user' do
      it 'not saves best answer in database' do
        patch :best, params: { id: answer }, format: :js

        answer.reload
        expect(answer.question.best_answer).to_not eq answer
      end
    end
  end

  describe 'POST #create' do
    context 'Authorized user' do
      before { login(user) }

      context 'with valid attributes ' do
        it 'saves a new answer in database ' do
          expect do
            post :create,
                 params: { question_id: question, answer: attributes_for(:answer) }, format: :js
          end.to change(Answer, :count).by(1)
        end

        it 'render create view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect do
            post :create,
                 params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(Answer, :count)
        end

        it 'render create view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'Unauthorized user' do
      context 'with valid attributes ' do
        it "doesn't saves a new answer in database" do
          expect do
            post :create,
                 params: { question_id: question, answer: attributes_for(:answer) }
          end.to_not change(Answer, :count)
        end

        it 'redirects to sign in view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
          expect(response).to redirect_to new_user_session_path
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect do
            post :create,
                 params: { question_id: question, answer: attributes_for(:answer, :invalid) }
          end.to_not change(Answer, :count)
        end

        it 'redirects to sign in view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe 'PATCH #update' do
    context 'Authorized author' do
      before { login(answer.user) }

      context 'with valid attributes' do
        it 'change answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'redirects to update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

        it 'does not change answer' do
          answer.reload
          expect(answer.body).to eq old_body
        end
      end
    end

    context 'Authorized user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'not change answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js

          expect(answer.body).to eq old_body
        end

        it 'render update' do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

        it 'does not change answer' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'redirects to update view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'unauthorized user' do
      context 'with valid attributes' do
        it 'not change answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }
          answer.reload

          expect(answer.body).to eq old_body
        end

        it 'redirects to sign in view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }
          expect(response).to redirect_to new_user_session_path
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }
        it 'does not change answer' do
          answer.reload

          expect(answer.body).to eq old_body
        end

        it 'redirects to sign in view' do
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authorized author' do
      before { login(answer.user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Authorized not author user' do
      let!(:answer) { create(:answer) }
      before { login(user) }

      it 'not deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'not render destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template nil
      end
    end

    context 'Unauthorized user' do
      let!(:answer) { create(:answer) }

      it 'not deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'redirects to sign in view' do
        delete :destroy, params: { id: answer }, format: :js
        should respond_with(401)
      end
    end
  end
end
