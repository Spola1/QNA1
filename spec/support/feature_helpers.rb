module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def sign_out
    click_on 'Log out'
  end

  def post_answer(question, answer_body)
    visit question_path(question)
    fill_in 'Body', with: answer_body
    click_on 'Post answer'
  end
end
