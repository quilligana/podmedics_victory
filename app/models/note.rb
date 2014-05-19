class Note < ActiveRecord::Base

  belongs_to :noteable, polymorphic: true
  belongs_to :user, touch: true
  belongs_to :specialty, touch: true

  validates :content, presence: true

  before_create :set_specialty

  after_commit :flush_cache

  # Cache functions

  def self.cached_find(id)
    Rails.cache.fetch([name, id]) { find_by_id(id) }
  end

  def flush_cache
    Rails.cache.delete([self.class.name, id])
  end

  def cached_user
    User.cached_find(user_id)
  end

  def cached_noteable 
    Rails.cache.fetch([self, "noteable"]) { noteable }
  end

  def cached_title
    Rails.cache.fetch([self, "title"]) { get_title }
  end
  
  def get_title
  	title.blank? ? noteable.title : title
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
