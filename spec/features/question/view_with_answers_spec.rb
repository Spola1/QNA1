require 'rails_helper'

feature 'User can view question with list of answers', "
  In order to view all answers for question
  As an User
  I'd like to be able to view list of answers
" do
  given(:question) { create(:question_with_answers) }

  scenario 'User view question with list of answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
