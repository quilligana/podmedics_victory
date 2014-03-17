class AddPreviewToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :preview, :boolean, default: false
  end
end
