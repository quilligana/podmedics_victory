class AddHasSlidesToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :has_slides, :boolean, default: true
  end
end
