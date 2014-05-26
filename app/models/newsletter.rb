class Newsletter < ActiveRecord::Base

  validates :subject, :body_content, :body_text, presence: true

  # send to all peopel who are allowed to receive newsletters
  def send_to_all
    User.newsletters_allowed.each do |user|
      UserMailer.delay.new_newsletter(user, self)
    end
  end
  handle_asynchronously :send_to_all

end
