require 'rails_helper'

feature 'User can vote for answer', "
  In order to encourage best answer
  As an authenticated user
  I'd like to be able to vote for answer
" do
  given(:user)       { create(:user) }
  given(:author)     { create(:user) }
  given!(:answer) { create(:answer, user: author) }

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(answer.question)
    end

    scenario 'change answer rating by voting' do
      within(".vote-#{answer.id}") { click_on 'Up' }
      within(".rating-#{answer.id}") do
        expect(page).to have_content '1'
      end
    end

    scenario 'change answer rating by voting' do
      within(".vote-#{answer.id}") do
        click_on 'Up'
        click_on 'Cancel'
      end
      within(".rating-#{answer.id}") do
        expect(page).to have_content '0'
      end
    end
    scenario 'change answer rating by voting' do
      within(".vote-#{answer.id}") { click_on 'Down' }
      within(".rating-#{answer.id}") do
        expect(page).to have_content '-1'
      end
    end
  end

  describe 'Authenticated author', js: true do
    before do
      sign_in(author)
      visit question_path(answer.question)
    end

    scenario 'cant change answer rating by voting' do
      expect(page).to_not have_css ".vote-#{answer.id}"
      within(".rating-#{answer.id}") do
        expect(page).to have_content '0'
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    before do
      visit question_path(answer.question)
    end

    scenario 'cant change answer rating by voting' do
      expect(page).to_not have_css ".vote-#{answer.id}"
      within(".rating-#{answer.id}") do
        expect(page).to have_content '0'
      end
    end
  end
end
