class AddMemberOnlyToFaqs < ActiveRecord::Migration
  def change
    add_column :faqs, :member_only, :boolean, default: false
  end
end
