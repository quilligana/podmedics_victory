class CreateVimeos < ActiveRecord::Migration
  def change
    create_table :vimeos do |t|
      t.integer :user_id
      t.integer :video_id
      t.decimal :progress,  default: 0
      t.boolean :completed, default: false

      t.timestamps
    end
    add_index :vimeos, :user_id
    add_index :vimeos, :video_id
  end
end
