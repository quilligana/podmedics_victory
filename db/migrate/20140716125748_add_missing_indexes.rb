class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :specialty_questions, :user_id
    add_index :specialty_questions, :specialty_id
    add_index :notes, [:noteable_id, :noteable_type]
    add_index :notes, :user_id
    add_index :notes, :specialty_id
    add_index :notes, :category_id
    add_index :votes, :user_id
    add_index :votes, :comment_id
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :comments, [:root_id, :root_type]
    add_index :comments, :user_id
    add_index :exams, :specialty_id
    add_index :badges, :specialty_id
  end
end
