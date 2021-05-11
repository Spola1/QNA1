require 'rails_helper'

feature 'user can register', "
  In order to ask questions
  As an unregistered user
  I'd like to be able to register
" do
  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to register' do
    fill_in 'Email', with: 'register@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries to register with invalid password confirmation' do
    fill_in 'Email', with: 'register@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'Unregistered user tries to register with invalid data' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end
end
