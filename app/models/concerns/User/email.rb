module Email
  extend ActiveSupport::Concern

  included do
    before_create :generate_unsubscribe_token
  end

  module ClassMethods
    def episode_notifications_allowed
      where(receive_new_episode_notifications: true)
    end

    def newsletters_allowed
      where(receive_newsletters: true)
    end
  end

  def generate_unsubscribe_token
    generate_token(:unsubscribe_token)
  end

  def unsubscribe
    self.receive_newsletters = false
    self.receive_status_updates = false
    self.receive_new_episode_notifications = false
    self.receive_social_notifications = false
    self.receive_help_request_notifications = false
    self.save!
  end
end
