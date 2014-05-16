class AddEmailOptInsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :receive_newsletters, :boolean, default: true
    add_column :users, :receive_reply_notifications, :boolean, default: true
    add_column :users, :receive_new_episode_notifications, :boolean, default: true
  end
end
