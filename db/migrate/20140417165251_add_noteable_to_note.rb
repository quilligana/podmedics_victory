class AddNoteableToNote < ActiveRecord::Migration
  def change
    add_column :notes, :noteable_id, :integer
    add_column :notes, :noteable_type, :string
  end
end
