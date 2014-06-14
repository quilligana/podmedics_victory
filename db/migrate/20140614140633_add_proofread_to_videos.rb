class AddProofreadToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :proofread, :boolean, default: false
  end
end
