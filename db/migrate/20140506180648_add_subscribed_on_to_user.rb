class AddSubscribedOnToUser < ActiveRecord::Migration
  def change
    add_column :users, :subscribed_on, :datetime
  end
end
