class Newsletter < ActiveRecord::Base

  validates :subject, :body_content, :body_text, presence: true

end
