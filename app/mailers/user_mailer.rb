class UserMailer < ActionMailer::Base
  default from: "admin@podmedics.com"

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Podmedics Password Reset'
  end

  def badge_award(user, badge)
    @user = user
    @badge = badge
    mail to: user.email, subject: 'Congratulations on Your New Podmedics Badge Award'
  end

  def professor_loss(user, specialty)
    @user = user
    @specialty = specialty
    mail to: user.email, subject: 'Notification of Your Professor Status'
  end

  def new_episode(user, video)
    @user = user
    @video = video
    mail to: user.email, subject: 'A New Video Has Been Posted'
  end
  handle_asynchronously :new_episode

end
