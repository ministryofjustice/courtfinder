class ApplicationController < ActionController::Base
  WillPaginate.per_page = 50

  def after_sign_in_path_for(resource)
    admin_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  def set_page_expiration
    expires_in(3.hours, public: true)
    headers['X-Varnish-Enable'] = '1'
  end
end
