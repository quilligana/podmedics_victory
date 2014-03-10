module OmniauthMacros

	def mock_twitter_auth_hash()
		OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
		{
		  :provider => 'twitter',
		  :uid => '123545',
		  :info => 
		  {
		    :name => 'mockuser'
		  },
		  :credentials => 
		  {
		    :token => 'mock_token',
		    :secret => 'mock_secret'
		  }
		})
	end

	def mock_facebook_auth_hash()
		OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
		{
		  :provider => 'twitter',
		  :uid => '123545',
		  :info => 
		  {
		    :name => 'mockuser',
		    :email => 'mock@email.com'
		  },
		  :credentials => 
		  {
		    :token => 'mock_token',
		    :secret => 'mock_secret'
		  }
		})
	end

end