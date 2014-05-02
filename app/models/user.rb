class User < ActiveRecord::Base

  has_secure_password

  has_many :user_questions, dependent: :destroy
  has_many :vimeos, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :specialty_questions, dependent: :destroy
  has_many :badges, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :notes, dependent: :destroy

  validates :email, presence: true, email: true
  validates :name, presence: true
  validates :website, url: { allow_blank: true }

  after_commit :flush_cache

  # Plans/Payments

  def mark_plan_selected
    update_attributes(selected_plan: true)
  end
  

  # Cache functions

  def self.cached_find(id)
    Rails.cache.fetch([name, id]) { find_by_id(id) }
  end

  def flush_cache
    Rails.cache.delete([self.class.name, id])
  end


  # Authentication System

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.oauth_token = auth.credentials.token
      user.name = auth.info.name

      if auth.provider == "twitter"
        user.email = "mail@example.com"
      else
        user.email = auth.info.email
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      end

      user.link_social_url(auth)

      password = SecureRandom.hex(64)
      user.password = password
      user.password_confirmation = password

      user.save!
    end
  end

  def link_social_url(auth)
    if auth.provider == "twitter"
      self.twitter = auth.info.urls.Twitter
    end

    if auth.provider == "facebook"
      self.facebook = auth.info.urls.Facebook
    end

    self.save
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  # Points

  def add_points_for_answer
    self.update_attributes(points: self.points + POINTS_PER_CORRECT_ANSWER)
  end

  def add_points_for_video
    self.update_attributes(points: self.points + POINTS_PER_WATCHED_VIDEO)
  end

  # Used on dashboard for graph
  def daily_stat(days_ago)
    rand(days_ago)
  end

end
