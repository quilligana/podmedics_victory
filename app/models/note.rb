class Note < ActiveRecord::Base

  belongs_to :noteable, polymorphic: true
  belongs_to :user
  belongs_to :specialty

  validates :content, presence: true

  before_create :set_specialty
  
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
