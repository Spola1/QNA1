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

  describe 'Register with Omniauth services' do
    describe 'GitHub' do
      scenario 'with correct data' do
        mock_auth_hash('github', email: 'test@test.ru')
        click_link "Sign in with GitHub"

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end

      scenario "can handle authentication error with GitHub" do
        invalid_mock('github')
        click_link "Sign in with GitHub"
        expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials"'
      end
    end

    describe 'Vkontakte' do
      scenario "with correct data, without email" do
        mock_auth_hash('vkontakte', email: nil)
        click_link "Sign in with Vkontakte"

        fill_in 'Email', with: 'register@test.com'
        click_on 'Sign up'
        expect(page).to have_content 'Welcome! You have signed up successfully.'
      end

      scenario "with correct data, with email" do
        mock_auth_hash('vkontakte', email: 'test@test.ru')
        click_link "Sign in with Vkontakte"
        expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
      end

      scenario "can handle authentication error with Vkontakte" do
        invalid_mock('vkontakte')
        click_link "Sign in with Vkontakte"

        expect(page).to have_content 'Could not authenticate you from Vkontakte because "Invalid credentials"'
      end
    end
  end
end
