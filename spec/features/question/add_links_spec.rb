require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user)      { create(:user) }
  given(:gist_url)  { 'https://gist.github.com/HelenRaven/b98553ef55c033f7c37e7596f6da3151' }
  given(:bad_url) { 'gist.github.com/HelenRaven/b98553ef55c033f7c37e7596f6da3151' }

  before do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'add link'

    fill_in 'Link name', with: 'My gist'
  end

  scenario 'User adds links when asks question' do
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

  scenario 'User adds invalid links when asks question' do
    fill_in 'Url', with: bad_url

    click_on 'Ask'

    expect(page).to have_content 'Links url is not a valid URL'
    expect(page).to_not have_link 'My gist', href: bad_url
  end
end
