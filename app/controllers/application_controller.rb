class ApplicationController < ActionController::Base
  WillPaginate.per_page = 50

  before_filter :set_page_expiration

  def after_sign_in_path_for(resource)
    admin_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  def set_page_expiration
    expires_in(3.hours, public: true)
  end
end
