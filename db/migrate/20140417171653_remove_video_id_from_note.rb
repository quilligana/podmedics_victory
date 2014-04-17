class RemoveVideoIdFromNote < ActiveRecord::Migration
  def change
  	remove_column :notes, :video_id
  end
end
