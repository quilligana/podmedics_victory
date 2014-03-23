class RemoveUserIdFromUserQuestions < ActiveRecord::Migration
  def change
    remove_index :user_questions, :user_id
    add_index :user_questions, :user_id
  end
end
