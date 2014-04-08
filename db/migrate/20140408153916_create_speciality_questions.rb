class CreateSpecialityQuestions < ActiveRecord::Migration
  def change
    create_table :speciality_questions do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
  end
end
