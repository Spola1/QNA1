require 'rails_helper'

feature 'User can view his awards', "
  In order to check wich is my answers are best
  As an answers's author
  I'd like to be able to view my awards
" do
  given(:user) { create(:user_with_awards) }

  scenario 'User view his awards', js: true do
    sign_in(user)
    visit awards_path

    user.awards.each do |award|
      expect(page).to have_content award.question.title
      expect(page).to have_content award.title
    end
  end
end
