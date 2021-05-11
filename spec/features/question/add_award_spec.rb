require 'rails_helper'

feature 'User can add award to question', "
  In order to encourage best answer
  As an question's author
  I'd like to be able to add award for best answer
" do
  given(:user)      { create(:user) }
  given(:question)  { create(:question_with_answers) }

  before do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
  end

  scenario 'User adds award when asks question' do
    fill_in 'Award title', with: 'new award'
    attach_file 'Image', "#{Rails.root}/spec/files/star.jpg"
    click_on 'Ask'

    visit questions_path
    click_on 'Edit'
    expect(page).to have_content 'new award'
  end

  scenario 'User adds invalid award when asks question' do
    fill_in 'Award title', with: 'new award'
    attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Ask'

    expect(page).to have_content 'Award image has an invalid content type'
  end
end
