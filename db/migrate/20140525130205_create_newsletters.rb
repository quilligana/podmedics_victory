class CreateNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|
      t.string :subject
      t.text :body_content
      t.text :body_text
      t.datetime :sent_at

      t.timestamps
    end
  end
end
