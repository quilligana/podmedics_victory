class AddReceiveHelpRequestNotificationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :receive_help_request_notifications, :boolean, default: true
  end
end
