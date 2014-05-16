require 'simplecov'
SimpleCov.start 'rails'
require 'rubygems'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'paperclip/matchers'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Paperclip::Shoulda::Matchers
  config.include LoginMacros
  config.include OmniauthMacros
  config.include MailerMacros
  config.include SpecialtyQuestionMacros
  config.include TransactionMacros
  config.include ProfileMacros

  OmniAuth.config.test_mode = true

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, js_errors: false)
  end

  Capybara.javascript_driver = :poltergeist

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
    reset_email
  end

  config.after(:each) do
    DatabaseCleaner.clean

    # Avatars in production and dev are stored on s3, so we can safely clean
    # up the system/avatars directory between tests.
    FileUtils.rm_rf("#{Rails.root}/system/avatars")
  end

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  if ENV['PARALLEL_TEST_GROUPS']
    Paperclip::Attachment.default_options[:path] =  ":rails_root/public/system/:rails_env/#{ENV['TEST_ENV_NUMBER'].to_i}/:class/:attachment/:id_partition/:filename"
    Paperclip::Attachment.default_options[:url] =   "/system/:rails_env/#{ENV['TEST_ENV_NUMBER'].to_i}/:class/:attachment/:id_partition/:filename"
  else
    Paperclip::Attachment.default_options[:path] =  ":rails_root/public/system/:rails_env/:class/:attachment/:id_partition/:filename"
    Paperclip::Attachment.default_options[:url] =   "/system/:rails_env/:class/:attachment/:id_partition/:filename"
  end
end
