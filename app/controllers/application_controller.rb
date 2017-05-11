class ApplicationController < ActionController::Base
  WillPaginate.per_page = 50

  def after_sign_in_path_for(resource)
    return admin_path if resource
    root_url
  end

  def after_sign_out_path_for(resource)
    return new_user_session_path if resource
    root_url
  end

  def set_vary_header
    headers['Vary'] = '*'
  end
end
