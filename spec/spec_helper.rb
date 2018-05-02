# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'
SimpleCov.start

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'webmock/rspec'
require 'headless'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each do |f|
  puts "requiring #{f}"
  require f
end
Dir[Rails.root.join('lib', '**', '*.rb')].each { |f| require f }

Faker::Config.locale = 'en-gb'

Capybara.javascript_driver = :webkit
# This is here so missing images from plugins are not failing tests.
Capybara.raise_server_errors = false

Capybara::Webkit.configure do |config|
  config.block_unknown_urls
  config.allow_url("http://ajax.googleapis.com/ajax")
  config.allow_url("https://assets.digital.cabinet-office.gov.uk/static")
end

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # to allow render_views to still work on rspec 3 / rails 4
  config.include RSpec::Rails::ViewRendering
  config.infer_spec_type_from_file_location!

  config.expect_with :rspec do |c|
    # ... explicitly enable both
    c.syntax = [:should, :expect]
  end

  config.include FactoryGirl::Syntax::Methods
  config.include Features::SessionHelpers, type: :feature
  config.include Features::SessionHelpers, type: :controller

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include Devise::TestHelpers, type: :controller

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.clean
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do |example|
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.before(:each, js: false) do
    Timecop.freeze(Time.now.utc)
  end

  config.after(:each, js: false) do
    Timecop.return
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.include IsExpectedHelper
end

require 'vcr'

VCR.configure do |config|
  config.default_cassette_options = { record: :new_episodes, serialize_with: :psych }
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock
  config.ignore_hosts '127.0.0.1', 'codeclimate.com'
  vcr_log_path = Rails.root.join('log', 'vcr.log')
  puts "VRC is logging to #{vcr_log_path}"
  config.debug_logger = File.open(Rails.root.join('log', 'vcr.log').to_s, 'w')
  config.allow_http_connections_when_no_cassette = false
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
