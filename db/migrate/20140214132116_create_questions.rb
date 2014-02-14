class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :stem
      t.string :answer_1
      t.string :answer_2
      t.string :answer_3
      t.string :answer_4
      t.string :answer_5
      t.integer :correct_answer
      t.text :explanation
      t.belongs_to :video, index: true

      t.timestamps
    end
  end
end
