#!/bin/sh
RAILS_ENV=test bundle install
RAILS_ENV=test bundle exec rake db:create
RAILS_ENV=test bundle exec rake db:migrate
RAILS_ENV=test bundle exec rake db:test:prepare
# Configuration for Webkit on ci: http://stjhimy.com/posts/31-fixing-the-error-webkit_server-cannot-connect-to-x-server
DISPLAY=localhost:1.0 xvfb-run RAILS_ENV=test bundle exec rspec spec

