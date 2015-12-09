class AddSpecialtyIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :specialty_id, :integer
    add_index :questions, :specialty_id
  end
end
