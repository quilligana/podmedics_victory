class AddIndexesToSpecialtyAndCategory < ActiveRecord::Migration
  def change
    add_index :specialties, :name, unique: true
    add_index :categories, :name, unique: true
  end
end
