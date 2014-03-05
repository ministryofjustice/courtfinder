class Admin::ApplicationController < ::ApplicationController
  protect_from_forgery

  before_filter :authenticate_user!

  def purge_cache(regex_as_string)
    unless Rails.env.development?
      Varnish::Client.new('127.0.0.1', 
                            request.host == "courttribunalfinder.service.gov.uk" ? 80 : 8081, 
                            ['http://', request.host].join).purge(regex_as_string)
    end
  end

  def purge_all_pages
    purge_cache('.*')
  end

  private  
  def authorised?
    redirect_to admin_path unless current_user.admin?
  end
end
