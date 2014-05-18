class AddReceiveStatusUpdatesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :receive_status_updates, :boolean, default: true
  end
end
