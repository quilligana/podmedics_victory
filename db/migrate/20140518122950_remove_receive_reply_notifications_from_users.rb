class RemoveReceiveReplyNotificationsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :receive_reply_notifications, :boolean
  end
end
