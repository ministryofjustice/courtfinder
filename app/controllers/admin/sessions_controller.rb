module Admin
  class SessionsController < ::Devise::SessionsController
    protect_from_forgery
    # layout "admin"
    # the rest is inherited, so it should work
  end
end
