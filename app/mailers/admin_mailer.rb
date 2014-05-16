class AdminMailer < ActionMailer::Base
  default from: 'admin@podmedics.com'

  # when a new specialty question is posted
  def new_specialty_question(specialty)
    @specialty = specialty
    mail to: 'ed@podmedics.com', subject: 'New Specialty Question'
  end

  # when a new comment is posted
  def new_comment(comment)
    @comment = comment
    mail to: 'ed@podmedics.com', subject: 'New Comment'
  end

end
