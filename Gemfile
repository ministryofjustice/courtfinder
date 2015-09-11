source 'https://rubygems.org'
#source 'http://gems.dsd.io/' unless ENV['TRAVIS'] || ENV['HEROKU']

gem 'rails', '~> 4.2.0.beta2'
gem 'pg'

gem 'byebug'
gem 'pry'
gem 'pry-nav'
gem 'awesome_print'


group :development, :test do
  gem 'faker'
  gem 'rspec-rails', '~>3.1.0'
  gem 'shoulda-matchers', '~>2.7.0'
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
  gem 'rspec-core', '~>3.1.0'
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
  gem 'capybara-email'
  gem 'simplecov', require: false, group: :test
  gem 'minitest' # stop warnings when running rspec, see https://github.com/rspec/rspec-rails/issues/758
  # Rails4 / rspec 3 compatibility
  gem 'rspec-collection_matchers'
  gem 'fuubar'
end


# Gems used only for assets and not required
# in production environments by default.
# assets group no longer available in rails 4.2
# group :assets do
gem 'sass-rails',   '~> 4.0.5'
gem 'coffee-rails', '~> 4.1.0'
gem 'uglifier', '>= 1.0.3'
#end

gem 'jquery-rails', '~> 2.1'# Rails unobtrusive scripting adapter for jQuery
gem 'friendly_id', '~>5.0.0'# Custom addresses instead of Ids
gem 'will_paginate'         # Paging
gem 'simple_form', '~>3.1.0' # Build forms with ease
gem 'rest-client'           # Accessing HTTP and REST resources (i.e. MoJ postcode lookup)
gem 'ckeditor_rails'        # Adds a rich WYSIWYG text area
gem 'geocoder'              # Check distances with latitude and longitude
gem 'devise', '~>3.4.1'     # Authentication
gem 'devise_invitable'      # Authentication invites
gem 'rmagick', require: false # Resize uploaded images
gem 'fog', '1.20.0'                   # Talks to cloud providers (e.g. S3)
gem 'unf'
gem 'carrierwave', github: 'carrierwaveuploader/carrierwave', branch: 'master'           # Handles file uploads
gem 'carrierwave-aws'
gem 'gmaps4rails', '~>1.5.6'# Maps and directions
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
gem 'google_drive'
gem 'verbs'

#Anotate tables
gem 'annotate'

# gems now needed on Rails 4+
gem 'protected_attributes'
