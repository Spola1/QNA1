require 'rails_helper'

feature 'User can view list of questions', "
  In order to find a suitable question
  As an User
  I'd like to be able to view list of questions
" do
  given!(:questions) { create_list(:question, 5) }

  scenario 'User view all questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
