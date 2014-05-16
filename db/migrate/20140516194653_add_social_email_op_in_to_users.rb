class AddSocialEmailOpInToUsers < ActiveRecord::Migration
  def change
    add_column :users, :receive_social_notifications, :boolean, default: true
  end
end
