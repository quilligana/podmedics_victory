class RemovePointsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :points, :integer
    add_column :users, :points, :integer, default: 0
  end
end
