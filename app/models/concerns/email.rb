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

  def unsubscribe(column)
    self[column] = false
    self.save!
  end
end