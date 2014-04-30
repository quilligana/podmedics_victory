class UserMailer < ActionMailer::Base
  default from: "admin@podmedics.com"

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Podmedics Password Reset'
  end
end
