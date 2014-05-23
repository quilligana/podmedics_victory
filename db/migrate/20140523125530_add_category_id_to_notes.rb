class AddCategoryIdToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :category_id, :integer

    Note.all.each do |note|
      note.category_id = note.specialty.category_id
      note.save
    end
  end
end
