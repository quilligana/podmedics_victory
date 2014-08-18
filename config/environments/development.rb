PodmedicsVictory::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  # temporarily enable for testing caching locally
  config.action_controller.perform_caching = false

  # temporarily enable a cache store for testing caching
  # required memcached to be running
  config.cache_store = :mem_cache_store

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # set to use letter opener for previewing mail
  config.action_mailer.delivery_method = :letter_opener

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.action_mailer.default_url_options = { :host => "localhost:3000" }

  WillPaginate.per_page = 50

  config.autosave_save_timer = 60000
  config.autosave_check_timer = 5000

  # Config for paperclip
  config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :access_key_id => ENV['AWS_ACCESS_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS']
    }
  }
  
  Paperclip::Attachment.default_options[:path] =  ":rails_root/public/system/avatars/:style/:filename"
  Paperclip::Attachment.default_options[:url] =   "/system/avatars/:style/:filename"


  DocRaptor.api_key ENV["DOCRAPTOR_API_KEY"]

  # Bullet config

  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
  end
end
