source 'https://rubygems.org'
source 'https://BnrJb6FZyzspBboNJzYZ@gem.fury.io/govuk/'
#source 'http://gems.dsd.io/' unless ENV['TRAVIS'] || ENV['HEROKU']

gem 'rails', '3.2.18'
gem 'pg'

gem 'byebug'
gem 'pry'
gem 'pry-nav'
gem 'awesome_print'

group :development, :test do
  gem 'faker'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request' #uncomment for use with rails pannel
  gem 'launchy'
  gem 'rb-fsevent', require: false
  gem 'guard-rspec'
  gem 'guard'
  gem 'guard-livereload'
  gem 'hirb'
  gem 'letter_opener'
  gem 'rubocop', require: false
  gem 'selenium-webdriver'
  gem 'rspec-core'
  gem "capybara-webkit"
end

group :test do
  gem 'webmock', '= 1.15.2'
  gem 'vcr'
  gem 'timecop'
  gem 'capybara', github: 'jnicklas/capybara'
  gem 'poltergeist'
  gem 'headless'
  gem 'database_cleaner'
  gem 'codeclimate-test-reporter', require: nil
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'turbo-sprockets-rails3'
end

gem 'jquery-rails', '~> 2.1'# Rails unobtrusive scripting adapter for jQuery
gem 'friendly_id'           # Custom addresses instead of Ids
gem 'will_paginate'         # Paging
gem 'simple_form'           # Build forms with ease
gem 'rest-client'           # Accessing HTTP and REST resources (i.e. MoJ postcode lookup)
gem 'ckeditor_rails'        # Adds a rich WYSIWYG text area
gem 'geocoder'              # Check distances with latitude and longitude
gem 'devise'                # Authentication
gem 'devise_invitable'      # Authentication invites
gem 'rmagick', require: false # Resize uploaded images
gem 'fog', '1.20.0'                   # Talks to cloud providers (e.g. S3)
gem 'carrierwave', github: 'carrierwaveuploader/carrierwave', branch: 'master'           # Handles file uploads
gem 'gmaps4rails'           # Maps and directions
gem 'unicorn'
gem 'haml-rails'            # Leaner markup with Haml.info
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
gem 'google_drive'
gem 'verbs'
