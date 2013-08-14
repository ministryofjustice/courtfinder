class Admin::ApplicationController < ::ApplicationController
  protect_from_forgery

  before_filter :authenticate_user!
  skip_before_filter :set_expires_to_3_hours
end
