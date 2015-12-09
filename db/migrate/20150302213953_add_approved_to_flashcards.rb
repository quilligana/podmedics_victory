class AddApprovedToFlashcards < ActiveRecord::Migration
  def change
    add_column :flashcards, :approved, :boolean, default: false
  end
end
