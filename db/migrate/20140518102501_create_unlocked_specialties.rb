class CreateUnlockedSpecialties < ActiveRecord::Migration
  def change
    create_table :unlocked_specialties do |t|
      t.belongs_to :user, index: true
      t.belongs_to :specialty, index: true

      t.timestamps
    end
  end
end
