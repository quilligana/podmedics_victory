class Note < ActiveRecord::Base

  belongs_to :noteable, polymorphic: true
  belongs_to :user, touch: true
  belongs_to :specialty, touch: true

  validates :content, presence: true

  before_create :set_specialty

  # Caching functions

  def cached_user
    User.cached_find(user_id)
  end
  
  def get_title
  	title.blank? ? noteable.title : title
  end

  def update(title, content)
  	self.title = title
  	self.content = content
  end

  private
  
    def set_specialty
      self.specialty = 
        if noteable_type == "Specialty"
          noteable
        else
          noteable.specialty
        end
    end
end
