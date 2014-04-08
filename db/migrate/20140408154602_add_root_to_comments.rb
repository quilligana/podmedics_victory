class AddRootToComments < ActiveRecord::Migration
  def change
    add_column :comments, :root_id, :integer
    add_column :comments, :root_type, :string
  end
end
