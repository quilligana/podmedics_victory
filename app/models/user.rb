class User < ActiveRecord::Base

  has_secure_password

  has_many :user_questions, dependent: :destroy
  has_many :vimeos, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :specialty_questions, dependent: :destroy
  has_many :badges, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :exams, dependent: :destroy
  has_many :sales

  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }, bucket: ENV['S3_USER_AVATAR_BUCKET_NAME']

  process_in_background :avatar

  validates_attachment :avatar, size: { in: 0..500.kilobytes }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  
  validates :email, 
    email_format: { 
      message: 'Not a valid email address',
      allow_nil: true
    }, 
    uniqueness: true
  validates :name, presence: true
  validates :website, url: { allow_blank: true }
  validates :password, presence: true,
    confirmation: true,
    length: {within: 5..30},
    on: :create

  after_commit :flush_cache
  before_save :set_avatar_file_name
  before_create :generate_unsubscribe_token

  # Plans/Payments

  def record_login
    self.login_count += 1
    self.last_login_at = Time.zone.now
    save
  end

  def mark_plan_selected
    update_attributes(selected_plan: true)
  end

  def start_subscription
    self.mark_plan_selected
    update_attributes(subscribed_on: Time.zone.now)
  end

  def expires_on
    subscribed_on + 1.year
  end

  def has_subscription_and_in_date?
    (self.subscribed_on && (Time.zone.now <= expires_on)) ? true : false
  end

  def has_selected_plan?
    self.selected_plan || self.admin ? true : false
  end

  def for_walkthrough?
    self.login_count == 1 ? true : false
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

      unless auth.provider == "twitter"
        user.email = auth.info.email
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      end

      user.link_social_url(auth)

      password = SecureRandom.hex(10)
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

  def add_points_for_specialty_answer
    self.update_attributes(points: self.points + POINTS_PER_USER_QUESTION_ANSWERED)
  end

  def add_points_for_accepted_answer
    self.update_attributes(points: self.points + POINTS_PER_ACCEPTED_ANSWER)
  end

  # Used on dashboard for graph

  def daily_stat(days_ago)
    rand(days_ago)
  end

  # Avatar

  def set_avatar_file_name
    unless avatar_file_name.nil?
      extension = File.extname(self.avatar_file_name)
      self.avatar_file_name = self.id.to_s + extension
    end
  end

  def get_avatar(style)
    if avatar.exists?
      avatar.url(style)
    else
      ActionController::Base.helpers.asset_path('avatar-128.jpg')
    end
  end

  # Retrieve users who are opted in

  def self.episode_notifications_allowed
    where(receive_new_episode_notifications: true)
  end

  def self.newsletters_allowed
    where(receive_new_episode_notifications: true)
  end

  # Email settings

  def generate_unsubscribe_token
    generate_token(:unsubscribe_token)
  end

  def unsubscribe
    set_receive_newsletters(false)
    set_receive_new_episode_notifications(false)
    set_receive_reply_notifications(false)
    set_receive_social_notifications(false)
    unsubscribed = true
    save
  end

  def set_receive_newsletters(allowed)
    receive_newsletters = allowed
    save
  end

  def set_receive_new_episode_notifications(allowed)
    receive_new_episode_notifications = allowed
    save
  end

  def set_receive_reply_notifications(allowed)
    receive_reply_notifications = allowed
    save
  end

  def set_receive_social_notifications(allowed)
    receive_social_notifications = allowed
    save
  end


end
