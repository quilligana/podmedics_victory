class AddSpecialtyIdToSpecialtyQuestion < ActiveRecord::Migration
  def change
    add_column :specialty_questions, :specialty_id, :integer
  end
end
