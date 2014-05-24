class User < ActiveRecord::Base
  include Avatars

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
  has_many :unlocked_specialties
  has_many :specialties, through: :unlocked_specialties

  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }, bucket: ENV['S3_USER_AVATAR_BUCKET_NAME']

  process_in_background :avatar, :processing_image_url => ActionController::Base.helpers.asset_path('avatar-128-pending.jpg')

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

  # Plans/Subs

  def record_login
    self.login_count += 1
    self.last_login_at = Time.zone.now
    save
  end

  def mark_plan_selected
    update_attributes(selected_plan: true)
  end

  def start_subscription_for_product(product)
    self.mark_plan_selected
    self.subscribed_on = Time.zone.now
    self.expires_on = self.subscribed_on.advance(months: product.duration)
    self.save!
  end

  def has_subscription_and_in_date?
    (self.subscribed_on && (Time.zone.now <= self.expires_on)) ? true : false
  end

  def has_selected_plan?
    self.selected_plan || self.admin ? true : false
  end

  def for_walkthrough?
    self.login_count == 1 ? true : false
  end

  def is_trial_member?
    !self.has_subscription_and_in_date? 
  end

  # Trial member specialty access

  def has_access_to?(specialty)
    specialties.include?(specialty) ? true : false
  end

  def has_reached_unlock_limit?
    specialties.count >= 2 ? true: false
  end

  def unlock_specialty(specialty)
    self.unlocked_specialties.create(specialty: specialty)
  end

  # Cache functions

  def self.cached_find(id)
    Rails.cache.fetch([name, id]) { find_by_id(id) }
  end

  def flush_cache
    Rails.cache.delete([self.class.name, id])
  end


  # Authentication System

  # Omni auth methods

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.extract_auth_data(auth)

      user.link_social_url(auth)

      user.generate_password

      user.save!
    end
  end

  def extract_auth_data(auth)
    self.provider = auth.provider
    self.uid = auth.uid
    self.oauth_token = auth.credentials.token
    self.name = auth.info.name

    unless auth.provider == "twitter"
      self.email = auth.info.email
      self.oauth_expires_at = Time.at(auth.credentials.expires_at)
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

  def generate_password
    password = SecureRandom.hex(10)
    self.password = password
    self.password_confirmation = password
  end

  # Password reset methods

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

  def self.percentile_stat
    distribution = []
    max_points = User.maximum(:points)
    (0..10).each_with_index do |percentile, index|
      if percentile == 0
        distribution[index] = 0
      else
        distribution[index] = self.where("points <= (?)", percentile *
                                          0.1 * max_points).count -
                              self.where("points <= (?)", (percentile - 1) *
                                          0.1 * max_points).count
      end
    end
    distribution
  end

  def percentile
    max_points = User.maximum(:points)
    user_points = self.points
    stat = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    (1..10).each_with_index do |percentile, index|
      if user_points > ((percentile - 1) * 0.1 * max_points) && user_points <= (percentile * 0.1 * max_points)
        number_users = User.where("points <= (?)", percentile *
                                          0.1 * max_points).count -
                       User.where("points <= (?)", (percentile - 1) *
                                          0.1 * max_points).count
        stat[index + 1] = number_users
      end
    end
    stat
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
    self.receive_newsletters = false
    self.receive_status_updates = false
    self.receive_new_episode_notifications = false
    self.receive_social_notifications = false
    self.receive_help_request_notifications = false
    self.save!
  end

end
