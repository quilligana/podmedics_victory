class RemoveUnsubscribedFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :unsubscribed, :boolean
  end
end
