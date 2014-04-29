class Admin::ApplicationController < ::ApplicationController
  protect_from_forgery

  before_filter :authenticate_user!

  def purge_cache(regex_as_string)
    unless Rails.env.development?
      begin
        Varnish::Client.new('127.0.0.1', 
                    request.host == "courttribunalfinder.service.gov.uk" ? 80 : 8081, 
                              ['http://', request.host].join).purge(regex_as_string)
      rescue Exception => ex
        logger.info("Failed to purge cache: #{ex.message}")
      end
    end
  end

  def purge_all_pages
    purge_cache('.*')
  end

  private
    def authorised?
      redirect_to admin_path unless current_user.admin?
    end

    def info_for_paper_trail
      {
        :ip => request.remote_ip
      }
    end

    def paper_trail_enabled_for_controller
      request.user_agent != 'Disable User-Agent'
    end
end
