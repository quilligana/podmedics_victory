# == Schema Information
#
# Table name: users
#
#  id                                 :integer          not null, primary key
#  email                              :string(255)
#  password_digest                    :string(255)
#  created_at                         :datetime
#  updated_at                         :datetime
#  admin                              :boolean          default(FALSE)
#  provider                           :string(255)
#  uid                                :string(255)
#  name                               :string(255)
#  oauth_token                        :string(255)
#  oauth_expires_at                   :datetime
#  points                             :integer          default(0)
#  password_reset_token               :string(255)
#  password_reset_sent_at             :datetime
#  facebook                           :string(255)
#  twitter                            :string(255)
#  website                            :string(255)
#  selected_plan                      :boolean          default(FALSE)
#  avatar_file_name                   :string(255)
#  avatar_content_type                :string(255)
#  avatar_file_size                   :integer
#  avatar_updated_at                  :datetime
#  login_count                        :integer          default(0)
#  last_login_at                      :datetime
#  subscribed_on                      :datetime
#  receive_newsletters                :boolean          default(TRUE)
#  receive_new_episode_notifications  :boolean          default(TRUE)
#  receive_social_notifications       :boolean          default(TRUE)
#  unsubscribe_token                  :string(255)
#  receive_status_updates             :boolean          default(TRUE)
#  avatar_processing                  :boolean
#  expires_on                         :datetime
#  receive_help_request_notifications :boolean          default(TRUE)
#  reminder_email_received            :boolean          default(FALSE)
#  terms_agreement                    :boolean          default(FALSE)
#

require 'faker'

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
    selected_plan true
    subscribed_on { Time.zone.now }
    expires_on { Time.zone.now + 6.months }

    factory :free_user do
      subscribed_on nil
      expires_on nil
    end

    factory :admin_user do
      admin true
    end

    factory :no_plan_user do
      selected_plan false
    end
  end
end
