class Admin::ApplicationController < ::ApplicationController
  protect_from_forgery

  before_filter :authenticate_user!

  def purge_cache(regex_as_string)
    unless Rails.env.development?
      begin
        varnish_host = (ENV['VARNISH_HOST'] || '127.0.0.1')
        varnish_port = (ENV['VARNISH_PORT'] || 6081)
        
        response = Varnish::Client.new(varnish_host,varnish_port,['http://', request.host].join).purge(regex_as_string)
        logger.info("PURGE: Host: #{request.host} @ #{varnish_host}:#{varnish_port}/#{regex_as_string}")
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
      ip = request.remote_ip
      network = if ip == '0.0.0.0' then 'localhost' else Resolv.getname(ip) end
      {
        ip: ip,
        network: network
      }
    end

    def paper_trail_enabled_for_controller
      request.user_agent != 'Disable User-Agent'
    end
end
