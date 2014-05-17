class AddUnsubscribeTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :unsubscribe_token, :string
  end
end
