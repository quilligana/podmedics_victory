class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title, index: true
      t.text :description
      t.belongs_to :specialty, index: true
      t.string :vimeo_identifier
      t.integer :duration

      t.timestamps
    end
  end
end
