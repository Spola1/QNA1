require 'rails_helper'

feature 'User can create answer', "
  In order to help another user and community
  As an User
  I'd like to be able to post an answer to a question
" do
  given(:user)     { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'post an answer' do
      fill_in 'Your answer', with: 'some answer'
      click_on 'Post answer'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        expect(page).to have_content 'some answer'
      end
    end

    scenario 'post an empty answer' do
      click_on 'Post answer'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'post an answer with attached files' do
      fill_in 'Your answer', with: 'some answer'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb",
                           "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Post answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries post an answer' do
    visit question_path(question)
    click_on 'Post answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
