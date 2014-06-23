class Unsubscribe
  def initialize(params)
    @params = params
    @unsubscribe_token = params[:unsubscribe_token]
  end

  def user
    @user ||=
      if @unsubscribe_token
        # what do we do if this return nil?
        user = User.find_by(unsubscribe_token: @unsubscribe_token)
        user ? user : nil
      elsif email
        User.find_by(email: email)
      end
  end

  def email
    @email ||=
      if @unsubscribe_token
        # likewise this needs to be able to return nil if user is not found
        user ? user.email : nil
      elsif @params[:unsub]
        @params[:unsub][:email]
      end
  end

  def unsubscribe
    if user
      EMAIL_TYPES.each do |email_type|
        if @params[:unsub][email_type] == "1"
          user.unsubscribe(email_type)
        end
      end
    end
  end

  def notice
    if !user
      "Sorry. Your account was not found."
    elsif @unsubscribe_token && !user
      'Sorry. Your email token is not valid.'
    else
      "#{email} has been unsubscribed"
    end
  end

end
