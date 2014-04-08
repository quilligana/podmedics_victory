class SpecialtyQuestion < ActiveRecord::Base
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :nested_comments, as: :root, class_name: "Comment"
end
