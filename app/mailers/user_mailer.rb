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
    mail to: user.email, subject: "There is a new video: #{@video.title}"
  end

  def new_reply(your_comment, reply)
    @user = your_comment.user
    @your_comment = your_comment
    @reply = reply
    mail to: @user.email, subject: 'You have a new reply'
  end

  def answer_accepted(answer)
    @user = answer.user
    @question = answer.root
    @answer = answer
    mail to: @user.email, subject: 'One of your answers has been accepted'
  end

end
