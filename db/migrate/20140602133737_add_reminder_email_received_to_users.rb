class AddReminderEmailReceivedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reminder_email_received, :boolean, default: false
  end
end
