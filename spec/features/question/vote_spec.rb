require 'rails_helper'

feature 'User can vote for question', "
  In order to encourage best question
  As an authenticated user
  I'd like to be able to vote for question
" do
  given(:user)       { create(:user) }
  given(:author)     { create(:user) }
  given!(:question)  { create(:question, user: author) }

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'change question rating by voting' do
      within(".vote-#{question.id}") { click_on 'Up' }
      within(".rating-#{question.id}") do
        expect(page).to have_content '1'
      end
    end

    scenario 'change question rating by voting' do
      within(".vote-#{question.id}") do
        click_on 'Up'
        click_on 'Cancel'
      end
      within(".rating-#{question.id}") do
        expect(page).to have_content '0'
      end
    end
    scenario 'change question rating by voting' do
      within(".vote-#{question.id}") { click_on 'Down' }
      within(".rating-#{question.id}") do
        expect(page).to have_content '-1'
      end
    end
  end

  describe 'Authenticated author', js: true do
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'cant change question rating by voting' do
      expect(page).to_not have_css ".vote-#{question.id}"
      within(".rating-#{question.id}") do
        expect(page).to have_content '0'
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    before do
      visit question_path(question)
    end

    scenario 'cant change question rating by voting' do
      expect(page).to_not have_css ".vote-#{question.id}"
      within(".rating-#{question.id}") do
        expect(page).to have_content '0'
      end
    end
  end
end
