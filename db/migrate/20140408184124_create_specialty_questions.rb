class CreateSpecialtyQuestions < ActiveRecord::Migration
  def change
    create_table :specialty_questions do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
  end
end
