class AddProfessorToSpecialties < ActiveRecord::Migration
  def change
    add_column :specialties, :professor, :integer
  end
end
