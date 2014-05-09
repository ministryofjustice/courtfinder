class ApplicationController < ActionController::Base
  WillPaginate.per_page = 50

  def after_sign_in_path_for(resource)
    admin_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  def enable_varnish
    headers['X-Varnish-Enable'] = '1'
  end

  def set_cache_control(timestamp)
    fresh_when(last_modified: timestamp.utc, public: true)
  end

  def set_vary_accept
    headers['Vary'] = 'Accept'
  end
end
