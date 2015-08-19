require 'simplecov'
SimpleCov.start do
  add_filter "/.bundle"
end

ENV["RAILS_ENV"] ||= 'test'
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'webmock/rspec'
require 'headless'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
Dir[Rails.root.join("lib/**/*.rb")].each {|f| require f}

Faker::Config.locale = 'en-gb'

Capybara.javascript_driver = :webkit
Capybara.current_driver = :rack_test

RSpec.configure do |config|
  config.include RSpec::Rails::ViewRendering
  config.infer_spec_type_from_file_location!
  config.expect_with :rspec do |c|
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
  config.ignore_hosts '127.0.0.1','codeclimate.com'
  config.debug_logger = File.open("#{Rails.root}\/log\/vcr.log", 'w')
  config.allow_http_connections_when_no_cassette = false
end
