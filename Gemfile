source 'https://rubygems.org'
#source 'http://gems.dsd.io/' unless ENV['TRAVIS'] || ENV['HEROKU']

gem 'rails', '4.2.7.1'
gem 'pg'

gem 'byebug'
gem 'pry'
gem 'pry-nav'
gem 'awesome_print'

group :development, :test do
  gem 'faker'
  gem 'rspec-rails', '~> 3.5.2'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'factory_girl_rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request' #uncomment for use with rails pannel
  gem 'launchy'
  gem 'rb-fsevent', require: false
  gem 'guard-rspec', require: false
  gem 'guard'
  gem 'guard-livereload'
  gem 'letter_opener'
  gem 'rubocop', require: false
  gem 'selenium-webdriver'
  gem 'rspec-core', '~> 3.5.4'
  gem "capybara-webkit"
end

group :test do
  gem 'webmock', '~> 3.0'
  gem 'vcr'
  gem 'timecop'
  gem 'capybara', github: 'jnicklas/capybara'
  gem 'poltergeist'
  gem 'headless'
  gem 'database_cleaner'
  gem 'codeclimate-test-reporter', require: nil
  gem 'capybara-email'
  gem 'simplecov', require: false
  gem 'minitest' # stop warnings when running rspec, see https://github.com/rspec/rspec-rails/issues/758
  # Rails4 / rspec 3 compatibility
  gem 'rspec-collection_matchers'
  gem 'spring-commands-rspec'
end


# Gems used only for assets and not required
# in production environments by default.
# assets group no longer available in rails 4.2
# group :assets do
gem 'sass-rails',   '~> 4.0.5'
gem 'coffee-rails', '~> 4.1.0'
gem 'uglifier', '>= 1.0.3'
#end

gem 'jquery-rails', '~> 4.3' # Rails unobtrusive scripting adapter for jQuery
gem 'friendly_id', '~> 5.2' # Custom addresses instead of Ids
gem 'will_paginate'         # Paging
gem 'simple_form', '~> 3.1' # Build forms with ease
gem 'rest-client'           # Accessing HTTP and REST resources (i.e. MoJ postcode lookup)
gem 'ckeditor_rails'        # Adds a rich WYSIWYG text area
gem 'geocoder'              # Check distances with latitude and longitude
gem 'devise', '~> 3.5.10'   # Authentication
gem 'devise_invitable'      # Authentication invites
gem 'rmagick', require: false # Resize uploaded images
gem 'carrierwave', '~> 1.0'
gem 'fog'
gem 'gmaps4rails', '1.5.7' # Maps and directions
gem 'unicorn'
gem 'haml-rails', '~>0.5.3' # Leaner markup with Haml.info
gem 'rdiscount'             # Enable Markdown in Haml
gem 'govuk_frontend_toolkit'# Sass helpers
gem 'global_phone'          # Phone number validation and formatting
gem 'nokogiri'              # HTML processing
gem 'moj_frontend_toolkit_gem', github: 'ministryofjustice/moj_frontend_toolkit_gem', tag: 'v0.1.0'
gem 'jbuilder'              # json api templating
gem 'httparty'
gem 'appsignal'
gem 'paper_trail', '~> 3.0'
gem 'figaro'
gem 'verbs'
gem 'sentry-raven'

#Anotate tables
gem 'annotate'

# gems now needed on Rails 4+
gem 'protected_attributes'
