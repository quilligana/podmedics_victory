class AddProofreadToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :proofread, :boolean, default: false
  end
end
