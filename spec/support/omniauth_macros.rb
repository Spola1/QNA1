module OmniauthHelpers
  OmniAuth.config.test_mode = true

  def mock_auth_hash(provider, email:)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new({
                                                                          'provider' => provider,
                                                                          'uid' => '123545',
                                                                          'info' => {
                                                                            'email' => email,
                                                                            'image' => 'mock_user_thumbnail_url'
                                                                          },
                                                                          'credentials' => {
                                                                            'token' => 'mock_token',
                                                                            'secret' => 'mock_secret'
                                                                          }
                                                                        })
  end

  def invalid_mock(provider)
    OmniAuth.config.mock_auth[provider.to_sym] = :invalid_credentials
  end
end
