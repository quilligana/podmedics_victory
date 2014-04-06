class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.integer :user_id
      t.integer :specialty_id
      t.string :level

      t.timestamps
    end
    add_index :badges, [:user_id, :created_at]
  end
end
