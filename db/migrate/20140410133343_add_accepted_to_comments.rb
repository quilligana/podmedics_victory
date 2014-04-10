class AddAcceptedToComments < ActiveRecord::Migration
  def change
    add_column :comments, :accepted, :boolean
  end
end
