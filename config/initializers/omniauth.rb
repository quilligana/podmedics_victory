OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['facebook_id'], ENV['facebook_secret'],
  :scope => 'email'
  provider :twitter, ENV['twitter_key'], ENV['twitter_secret']

  OmniAuth.config.on_failure = SessionsController.action(:oauth_failure)
end