class ApplicationController < ActionController::Base
  WillPaginate.per_page = 50

  def after_sign_in_path_for(resource)
    if resource
      admin_path
    else
      root_url
    end
  end

  def after_sign_out_path_for(resource)
    if resource
      new_user_session_path
    else
      root_url
    end
  end

  def set_vary_header
    headers['Vary'] = '*'
  end
end
