module MailerMacros
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def second_last_email
    ActionMailer::Base.deliveries(-2)
  end

  def reset_email
    ActionMailer::Base.deliveries = []
  end
end
