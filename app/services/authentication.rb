class Authentication
  def initialize(params, omniauth = nil)
    @params = params
    @omniauth = omniauth
  end

  def user
    @user ||= @omniauth ? user_from_omniauth : user_with_password
  end

  def authenticated?
    user.present?
  end

  def existing_non_omniauth?
    if @omniauth
      # Returns whether a non-oauth account with the oauth email address already exists
      existing_user = User.find_by(email: @omniauth[:info][:email])

      existing_user && existing_user.uid.nil?
    end
  end

  def error_message
    if existing_non_omniauth?
      "Account already exists with email address #{@omniauth[:info][:email]}"
    elsif !authenticated?
      'Email or password is invalid'
    end
  end

private

  def user_with_password
    user = User.find_by(email: @params[:email])
    user && user.authenticate(@params[:password])
  end

  def user_from_omniauth
    # Make sure we can't create an oauth account with an already existing email address.
    # Can't constrain email address uniqueness at the model level because we must allow nil
    # email addresses due to Twitter not returning an email address.
    unless existing_non_omniauth?
      User.where(@omniauth.slice(:provider, :uid)).first_or_initialize.tap do |user|
        extract_auth_data(user)
        user.link_social_url(@omniauth)
        user.generate_password
        user.save!
      end
    end
  end

  def extract_auth_data(user)
    user.provider = @omniauth[:provider]
    user.uid = @omniauth[:uid]
    user.oauth_token = @omniauth[:credentials][:token]
    user.name = @omniauth[:info][:name]

    unless @omniauth.provider == "twitter"
      user.email = @omniauth[:info][:email]
      user.oauth_expires_at = Time.at(@omniauth.credentials.expires_at)
    end
  end
end