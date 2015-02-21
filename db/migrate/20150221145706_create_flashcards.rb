class CreateFlashcards < ActiveRecord::Migration
  def change
    create_table :flashcards do |t|
      t.integer :specialty_id
      t.integer :video_id
      t.integer :views, default: 0
      t.string :title
      t.text :epidemiology
      t.text :pathology
      t.text :causes
      t.text :signs
      t.text :symptoms
      t.text :inv_cultures
      t.text :inv_bloods
      t.text :inv_imaging
      t.text :inv_scopic
      t.text :inv_functional
      t.text :treat_cons
      t.text :treat_medical
      t.text :treat_surgical

      t.timestamps
    end

    add_index :flashcards, :specialty_id
    add_index :flashcards, :video_id
    add_index :flashcards, :title
  end
end
