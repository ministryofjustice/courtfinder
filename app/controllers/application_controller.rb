class ApplicationController < ActionController::Base
  protect_from_forgery

  WillPaginate.per_page = 20
end
