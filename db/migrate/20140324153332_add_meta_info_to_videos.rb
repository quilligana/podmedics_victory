class AddMetaInfoToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :speaker_name, :string
    add_column :videos, :views, :integer, default: 0
    add_column :videos, :file_name, :string
  end
end
