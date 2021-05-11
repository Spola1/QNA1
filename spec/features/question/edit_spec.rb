require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an Author of question
  I'd like to be able to edit my question
" do
  given!(:user)     { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated author', js: true do
    background do
      sign_in(question.user)
      visit questions_path
    end

    scenario 'edits his question' do
      click_on 'Edit'

      within('.questions') do
        fill_in 'Title', with: 'new title'
        fill_in 'Your question', with: 'edited question'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to have_content 'new title'
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      click_on 'Edit'
      within('.questions') do
        fill_in 'Your question', with: ''
        click_on 'Save'

        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea'
      end
      within('.question-errors') do
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Authenticated user', js: true do
    scenario "tries to edit other user's question" do
      sign_in(user)
      visit questions_path

      within('.questions') do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end
end
