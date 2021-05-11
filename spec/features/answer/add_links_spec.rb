require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
" do
  given(:user)     { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/HelenRaven/b98553ef55c033f7c37e7596f6da3151' }
  given(:bad_url) { 'bad_url.com' }

  before do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'some answer'
    click_on 'add link'
    fill_in 'Link name', with: 'My gist'
  end

  scenario 'User adds link when post answer', js: true do
    fill_in 'Url', with: gist_url

    click_on 'Post answer'

    expect(page).to have_link 'My gist', href: gist_url
  end

  scenario 'User adds invalid link when post answer', js: true do
    fill_in 'Url', with: bad_url

    click_on 'Post answer'

    expect(page).to have_content 'Links url is not a valid URL'
    expect(page).to_not have_link 'My gist', href: bad_url
  end
end
