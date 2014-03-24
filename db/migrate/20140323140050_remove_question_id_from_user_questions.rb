class RemoveQuestionIdFromUserQuestions < ActiveRecord::Migration
  def change
    remove_index :user_questions, :question_id
    add_index :user_questions, :question_id
  end
end
