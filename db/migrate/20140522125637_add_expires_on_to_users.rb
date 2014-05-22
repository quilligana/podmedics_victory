class AddExpiresOnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :expires_on, :datetime
  end
end
