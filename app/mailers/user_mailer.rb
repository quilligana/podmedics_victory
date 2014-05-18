class UserMailer < ActionMailer::Base
  default from: "admin@podmedics.com"

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Podmedics Password Reset'
  end

  def badge_award(user, badge)
    if user.receive_status_updates?
      @user = user
      @badge = badge
      mail to: user.email, subject: 'Congratulations on Your New Podmedics Badge Award'
    end
  end

  def professor_loss(user, specialty)
    if user.receive_status_updates?
      @user = user
      @specialty = specialty
      mail to: user.email, subject: 'Notification of Your Professor Status'
    end
  end

  def new_episode(user, video)
    if user.receive_new_episode_notifications?
      @user = user
      @video = video
      mail to: user.email, subject: "New Podmedics Video: #{@video.title}"
    end
  end

  def new_reply(user, your_comment, reply)
    if user.receive_social_notifications?
      @user = user
      @your_comment = your_comment
      @reply = reply
      mail to: user.email, subject: 'You have a new reply'
    end
  end

  def answer_accepted(user, answer)
    if user.receive_social_notifications?
      @user = user
      @question = answer.root
      @answer = answer
      mail to: user.email, subject: 'One of your answers has been accepted'
    end
  end

end
