class Post < ActiveRecord::Base

  belongs_to :author
  validates :title, :content, :author_id, presence: true
  delegate :twitter, to: :author, prefix: true
  delegate :facebook, to: :author, prefix: true

  has_attached_file :title_image, 
    styles: { :medium => "720x210>"},
    bucket: ENV['S3_POST_IMAGES_BUCKET_NAME']
  validates_attachment_content_type :title_image, :content_type => /\Aimage\/.*\Z/

end
