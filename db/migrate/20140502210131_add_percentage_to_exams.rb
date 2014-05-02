class AddPercentageToExams < ActiveRecord::Migration
  def change
    add_column :exams, :percentage, :integer, default: 0
  end
end
