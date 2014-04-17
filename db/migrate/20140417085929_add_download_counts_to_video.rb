class AddDownloadCountsToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :slide_download_count, :integer
    add_column :videos, :audio_download_count, :integer
    add_column :videos, :video_download_count, :integer
  end
end
