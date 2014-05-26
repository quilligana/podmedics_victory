class AdminMailer < ActionMailer::Base
  default from: 'donotreply@podmedics.com'
  layout 'user_mailer', only: [:test_newsletter]

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
    # a basic user needs to be include for the template to work
    @user = User.first
    mail to: 'ed@podmedics.com', subject: @newsletter.subject
  end

end
