require 'rails_helper'

feature 'Author can delete his answer', "
  In order to delete answer
  As an authenticated user and question author
  I'd like to be able to delete my answer
" do
  given(:answer) { create(:answer) }
  given(:user)   { create(:user) }

  scenario 'Authenticated author try to delete his answer' do
    sign_in(answer.user)
    visit question_path(answer.question)
    click_on 'Delete answer'

    expect(page).to have_content 'Your answer was successfully deleted.'
    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated not author user try to delete answer' do
    sign_in(user)
    visit question_path(answer.question)

    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Unauthenticated user try to delete answer' do
    visit answer_path(answer)

    expect(page).to_not have_link 'Delete answer'
  end
end
