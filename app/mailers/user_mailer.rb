class UserMailer < ActionMailer::Base
  default from: "contact@podmedics.com"

  def welcome_free_plan(user)
    @user = user
    mail to: user.email, subject: 'Welcome to Podmedics', from: 'ed@podmedics.com'
  end

  def welcome_paid_plan(user)
    @user = user
    mail to: user.email, subject: 'Welcome to Podmedics', from: 'ed@podmedics.com'
  end

  def new_newsletter(user, newsletter)
    @user = user
    @newsletter = newsletter
    mail to: user.email, subject: newsletter.subject
  end

  def one_week_hello(user)
    @user = user
    mail to: user.email, subject: 'We hope you are enjoying Podmedics'
  end

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
      unless @user.email.blank?
        mail to: @user.email, subject: @video.title
      end
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

  def new_specialty_question(user, question)
    if user.receive_help_request_notifications?
      @user = user
      @question = question
      mail to: user.email, subject: 'Another Podmedics user needs your help!'
    end
  end

  def flashcard_submission(user)
    @user = user
    mail to: user.email, subject: 'Flashcard submitted'
  end

  def flashcard_approval(flashcard)
    @flashcard = flashcard
    @user = flashcard.user
    mail to: @user.email, subject: 'Your flashcard was approved'
  end

end
