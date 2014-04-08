class User < ActiveRecord::Base

  has_secure_password
  has_many :user_questions, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :speciality_questions, dependent: :destroy
  has_many :badges, dependent: :destroy
  validates :email, presence: true, email: true
  validates :name, presence: true

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token

      unless auth.provider == "twitter"
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      end

      unless auth.provider == "twitter"
        user.email = auth.info.email
      else
        user.email = "mail@example.com"
      end

      password = SecureRandom.hex(64)
      user.password = password
      user.password_confirmation = password

      user.save!
    end
  end

  def add_points_for_answer
    current_points = self.points
    new_points = current_points + POINTS_PER_CORRECT_ANSWER
    self.update_attributes(points: new_points)
  end
end
