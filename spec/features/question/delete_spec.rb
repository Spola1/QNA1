require 'rails_helper'

feature 'Author can delete his question', "
  In order to delete question
  As an authenticated user and question author
  I'd like to be able to delete my question
" do
  given(:question) { create(:question) }
  given(:user)     { create(:user) }

  scenario 'Authenticated author try to delete his question' do
    sign_in(question.user)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario 'Authenticated not author user try to delete question' do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Unauthenticated user try to delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
