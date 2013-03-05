class ApplicationController < ActionController::Base
  protect_from_forgery

  # layout :app_layout

  # def app_layout
  #   path = request.env['PATH_INFO']

  #   if /admin/i =~ 'admin'
  #     return 'admin'
  #   else
  #     return 'application'
  #   end
  # end
end
