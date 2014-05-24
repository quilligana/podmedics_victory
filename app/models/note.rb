class Note < ActiveRecord::Base

  belongs_to :noteable, polymorphic: true
  belongs_to :user, touch: true
  belongs_to :specialty, touch: true
  belongs_to :category

  validates :content, presence: true

  before_create :set_specialty
  before_create :set_category

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

  def self.get_notes(user, specialty_id = false, category_id = false)
    if specialty_id
      specialty = Specialty.friendly.find(specialty_id)
      notes = Note.specialty_notes(specialty.id)
      title = specialty.name
    elsif category_id
      notes = Note.category_notes(category_id)
      title = Category.find(category_id).name
    else
      notes = all
      title = "all"
    end

    user_notes = notes.where(user: user)
    sorted_notes = Note.sort_notes(user_notes)

    return title, sorted_notes
  end

  def self.specialty_notes(specialty_id)
    where(specialty_id: specialty_id)
  end

  def self.category_notes(category_id)
    where(category_id: category_id)
  end

  def self.sort_notes(notes)
    result = Array.new()

    notes.group_by(&:category_id).each do |category|
      category = category[1]
      category_array = Array.new()

      category.group_by(&:specialty_id).each do |specialty|
        specialty_array = specialty[1]
        
        category_array.push(specialty_array)
      end
      result.push(category_array)
    end

    result
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

    def set_category
      self.category = self.specialty.category
    end
end
