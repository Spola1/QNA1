require 'rails_helper'

feature 'Author of question can choose the best answer', "
  In order to check an answer with solution of problem
  As an question author
  I'd like to be able to check best answer
" do
  given(:user)     { create(:user) }
  given(:question) { create(:question_with_answers, answers_count: 5) }
  given(:question_with_best) { create(:question_with_answers, :with_best_answer, answers_count: 5) }
  given(:answer) { create(:answer, question: question_with_best) }

  describe 'Authorized question author', js: true do
    scenario 'choose the best answer' do
      sign_in(question.user)
      visit question_path(question)

      within(".answer-#{question.answers.last.id}") do
        click_on 'Choose'

        expect(page).to have_content "Best answer"
        expect(page).to have_content question.answers.last.body
      end
    end

    scenario 'change the best answer' do
      sign_in(question_with_best.user)
      visit question_path(question_with_best)

      within(".answer-#{question_with_best.best_answer.id}") do
        expect(page).to have_content "Best answer"
      end

      within(".answer-#{question_with_best.answers.last.id}") do
        click_on 'Choose'

        expect(page).to have_content "Best answer"
      end

      question_with_best.reload
      expect(question_with_best.best_answer).to eq question_with_best.answers.last
    end
  end

  describe 'Authorized user', js: true do
    scenario 'can not choose the best answer' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Choose'
    end
  end

  describe 'Unauthorized user', js: true do
    scenario 'can not choose the best answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Choose'
    end
  end
end
