class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title
      t.datetime :date
      t.decimal :price
      t.text :description
      t.string :event_link

      t.timestamps
    end
  end
end
