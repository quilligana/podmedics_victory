class AdminMailer < ActionMailer::Base
  default from: 'donotreply@podmedics.com'

  def new_specialty_question(specialty)
    @specialty = specialty
    mail to: 'ed@podmedics.com', subject: 'New Specialty Question'
  end

  def new_comment(comment)
    @comment = comment
    mail to: 'ed@podmedics.com', subject: 'New Comment'
  end

end
