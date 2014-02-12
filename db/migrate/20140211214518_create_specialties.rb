class CreateSpecialties < ActiveRecord::Migration
  def change
    create_table :specialties do |t|
      t.string :name
      t.belongs_to :category, index: true

      t.timestamps
    end
  end
end
