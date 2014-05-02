class AddSelectedPlanToUsers < ActiveRecord::Migration
  def change
    add_column :users, :selected_plan, :boolean, default: false
  end
end
