class AdminMailer < ActionMailer::Base
  default from: 'ed@podmedics.com'
  layout 'user_mailer', only: [:test_newsletter, :new_test_episode]

  def new_specialty_question(specialty)
    @specialty = specialty
    mail to: 'ed@podmedics.com', subject: 'New Specialty Question'
  end

  def new_comment(comment)
    @comment = comment
    mail to: 'ed@podmedics.com', subject: 'New Comment'
  end

  def test_newsletter(newsletter)
    @newsletter = newsletter
    # a basic user needs to be included for user mailer template
    # to generate a unsub token
    @user = User.first
    mail to: 'ed@podmedics.com', subject: @newsletter.subject
  end

  def new_test_episode(video)
    @user = User.first
    @video = video
    mail to: 'ed@podmedics.com', subject: "#{@video.title} Video", template_path: 'user_mailer', template_name: 'new_episode'
  end

  def new_payment(user)
    @user = user
    mail to: 'ed@podmedics.com', subject: 'New Podmedics Sale'
  end

  def payment_failed(user)
    @user = user
    mail to: 'ed@podmedics.com', subject: 'Podmedics Payment Failed'
  end

end
