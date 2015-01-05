require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Courtfinder
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib #{config.root}/app/forms)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # config.logger = ::Logger.new("#{Rails.root}/log/#{Rails.env}.log")

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    config.postcode_lookup_service_url = ENV['MAPIT_PRIMARY'] || 'http://mapit.mysociety.org/postcode'#'http://mapit.service.dsd.io/postcode'
    config.backup_postcode_lookup_service_url = ENV['MAPIT_SECONDARY'] || 'http://mapit.mysociety.org/postcode'

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.precompile += %w(
      gov-static/gov-goodbrowsers.css
      gov-static/gov-ie6.css
      gov-static/gov-ie7.css
      gov-static/gov-ie8.css
      gov-static/gov-fonts.css
      gov-static/gov-fonts-ie8.css
      gov-static/gov-print.css
      moj-base.css
      gov-static/gov-ie.js
    )

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Devise suggests we use this
    config.assets.initialize_on_precompile = false

    # MOJ Toolkit

    # app title appears in the header bar
    config.app_title = 'Court finder'

    # phase governs text indicators and highlight colours
    # presumed values: alpha, beta, live
    config.phase = 'beta'

    # known values: information, service
    config.product_type = 'service'

    # govbranding switches on or off the crown logo, full footer and NTA font
    config.govbranding = true

    # feedback_email is the address linked in the alpha/beta bar asking for feedback
    config.feedback_email = 'test@example.com'
  end
end
