class AddLoginFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :login_count, :integer, default: 0
    add_column :users, :last_login_at, :datetime
  end
end
