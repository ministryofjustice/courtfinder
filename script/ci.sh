#!/bin/sh
RAILS_ENV=test bundle install
RAILS_ENV=test bundle exec rake db:create
RAILS_ENV=test bundle exec rake db:migrate
RAILS_ENV=test bundle exec rake db:test:prepare
RAILS_ENV=test bundle exec rspec spec

