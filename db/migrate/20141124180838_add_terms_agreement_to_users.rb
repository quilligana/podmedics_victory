class AddTermsAgreementToUsers < ActiveRecord::Migration
  def change
    add_column :users, :terms_agreement, :boolean, default: false
  end
end
