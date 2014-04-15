class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name
      t.string :tagline
      t.string :twitter
      t.string :facebook

      t.timestamps
    end
  end
end
