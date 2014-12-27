class AddUgradedToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :upgraded, :boolean, default: false
  end
end
