class Unsubscribe
  def initialize(params)
    @params = params
    @unsubscribe_token = params[:unsubscribe_token]
  end

  def user
    @user ||=
      if @unsubscribe_token
        puts "token"
        User.find_by(unsubscribe_token: @unsubscribe_token)
      elsif email
        puts "email"
        User.find_by(email: email)
      end
  end

  def email
    @email ||=
      if @unsubscribe_token
        user.email
      elsif @params[:unsub]
        @params[:unsub][:email]
      end
  end

  def unsubscribe
    if @user
      if @params[:unsub][:receive_newsletters] == "1"
        @user.unsubscribe(:receive_newsletters)
      end

      if @params[:unsub][:receive_status_updates] == "1"
        @user.unsubscribe(:receive_status_updates)
      end

      if @params[:unsub][:receive_new_episode_notifications] == "1"
        @user.unsubscribe(:receive_new_episode_notifications)
      end

      if @params[:unsub][:receive_social_notifications] == "1"
        @user.unsubscribe(:receive_social_notifications)
      end

      if @params[:unsub][:receive_help_request_notifications] == "1"
        @user.unsubscribe(:receive_help_request_notifications)
      end
    end
  end

  def notice
    if @unsubscribe_token && !user
      'Sorry. Your email token is not valid.'
    else
      "#{email} has been unsubscribed"
    end
  end

end