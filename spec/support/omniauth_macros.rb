module OmniauthMacros

	def mock_twitter_auth_hash()
		OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
		{
		  provider: 'twitter',
		  uid: '123545',
		  info: 
		  {
		    name: 'mockuser',
		    urls: { Facebook: 'http://www.facebook.com' }
		  },
		  credentials:
		  {
		    token: 'mock_token',
		    secret: 'mock_secret'
		  }
		})
	end

	def mock_facebook_auth_hash()
		OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
		{
		  provider: 'facebook',
		  uid: '123545',
		  info: 
		  {
		    name: 'mockuser',
		    email: 'mail@example.com',
		    urls: { Facebook: 'http://www.twitter.com' }
		  },
		  credentials:
		  {
		    token: 'mock_token',
		    secret: 'mock_secret',
		    expires_at: 7.days.since(Time.now).to_i
		  }
		})
	end

end