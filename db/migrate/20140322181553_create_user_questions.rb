class CreateUserQuestions < ActiveRecord::Migration
  def change
    create_table :user_questions do |t|
      t.integer :user_id
      t.integer :question_id
      t.boolean :correct_answer, default: false

      t.timestamps
    end
    add_index :user_questions, :question_id, unique: true
    add_index :user_questions, :user_id, unique: true
  end
end
