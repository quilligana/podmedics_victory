class AddTitleImageAttachmentToPosts < ActiveRecord::Migration

  def self.up
    add_attachment :posts, :title_image
  end

  def self.down
    remove_attachment :posts, :title_image
  end

end

