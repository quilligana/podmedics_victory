class User < ActiveRecord::Base
  include Avatars
  include Email

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

  scope :has_selected_plan, -> { where(selected_plan: true) }
  scope :expired_before, -> time { where("expires_on < :date", {date: time}) }
  scope :expired_after, -> time { where("expires_on >= :date", {date: time})}
  scope :never_subscribed, -> { where("expires_on is NULL")}
  
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

  def to_s
    name
  end

  # Plans/Subs

  def self.registered_a_week_ago
    where("created_at >= :one_week AND created_at <= :six_days", one_week: (Time.zone.now - 1.weeks), six_days: (Time.zone.now - 6.days))
  end

  def paypal_url(product, return_url)
    Paypal.new(product, self, return_url).generate_url
  end

  def self.trial(boolean)
    boolean ? has_selected_plan.never_subscribed : !has_selected_plan.never_subscribed
  end

  def record_login
    self.login_count += 1
    self.last_login_at = Time.zone.now
    save
  end

  def mark_plan_selected
    update_attributes(selected_plan: true)
  end

  def start_subscription_for_product(product)
    activate_subscription(product)
    send_user_and_admin_notifications
  end

  def activate_subscription(product)
    self.mark_plan_selected
    self.subscribed_on = Time.zone.now
    self.expires_on = self.subscribed_on.advance(months: product.duration)
    self.save!
  end

  def send_user_and_admin_notifications
    UserMailer.delay.welcome_paid_plan(self)
    AdminMailer.delay.new_payment(self)
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

  def suitable_for_reminder?
    self.is_trial_member? && self.has_selected_plan? && !self.reminder_email_received ? true : false
  end

  def self.send_one_week_reminders
    users_for_reminders = registered_a_week_ago.has_selected_plan.never_subscribed
    users_for_reminders.each do |user|
      if user.suitable_for_reminder?
        UserMailer.delay.one_week_hello(user)
        user.update_attributes(reminder_email_received: true)
      end
    end
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


  # User profile social links

  def link_social_url(auth)
    if auth
      if auth[:provider] == "twitter"
        self.twitter = auth[:info][:urls][:Twitter]
      end

      if auth[:provider] == "facebook"
        self.facebook = auth[:info][:urls][:Facebook]
      end

      self.save
    end
  end


  # Password methods

  def generate_password
    password = SecureRandom.hex(10)
    self.password = password
    self.password_confirmation = password
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

  def add_points(reason)
    self.update_attributes(points: self.points + POINTS[reason])
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
end
