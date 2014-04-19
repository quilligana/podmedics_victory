class Note < ActiveRecord::Base
  before_create :set_specialty

  belongs_to :noteable, polymorphic: true
  belongs_to :user
  belongs_to :specialty

  validates :content, presence: true

  def get_title
  	title.blank? ? noteable.title : title
  end

  def update(title, content)
  	self.title = title
  	self.content = content
  end

  private
  
    def set_specialty
      if self.noteable_type == "Specialty"
        self.specialty = self.noteable
      else
        self.specialty = self.noteable.specialty
      end
    end
end
