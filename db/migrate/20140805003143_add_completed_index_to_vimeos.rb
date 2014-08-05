class AddCompletedIndexToVimeos < ActiveRecord::Migration
  def change
    add_index :vimeos, :completed
  end
end
