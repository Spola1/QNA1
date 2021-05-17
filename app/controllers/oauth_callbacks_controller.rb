class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    sign_in_with_provider('Github')
  end

  def vkontakte
    sign_in_with_provider('Vkontakte')
  end

  private

  def sign_in_with_provider(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      session["omniauth"] = request.env['omniauth.auth'].except(:extra)
      flash.now[:notice] = "Please enter your email and press 'Sign up'"
      redirect_to new_user_registration_url
    end
  end
end
