require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an Author of answer
  I'd like to be able to edit my answer
" do
  given!(:user)     { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer_with_file) { create(:answer_with_file) }
  given!(:answer)   { create(:answer, question: question) }

  describe 'Authenticated author', js: true do
    background do
      sign_in(answer.user)
      visit question_path(answer.question)
    end

    scenario 'edits his answer' do
      click_on 'Edit'

      within('.answers') do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      click_on 'Edit'
      within('.answers') do
        fill_in 'Your answer', with: ''
        click_on 'Save'
        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end
      within('.answer-errors') do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'attach files while editing his answer' do
      click_on 'Edit'
      within('.answers') do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Save'
      end

      click_on 'Edit'
      within('.answers') do
        attach_file 'File', "#{Rails.root}/README.md"
        click_on 'Save'
      end
      wait_for_ajax
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'README.md'
    end
  end
  describe 'Authenticated author', js: true do
    background do
      sign_in(answer_with_file.user)
      visit question_path(answer_with_file.question)
    end
    scenario 'delete files while editing his answer' do
      within('.answers') do
        click_on(id: "delete-file-#{answer_with_file.files.first.id}")

        expect(page).to_not have_link answer_with_file.files.first.filename.to_s
      end
    end
  end

  describe 'Authenticated user', js: true do

    scenario "tries to edit other user's answer" do
      sign_in(user)
      visit question_path(answer.question)

      within('.answers') do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
