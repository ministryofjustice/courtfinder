class Admin::ApplicationController < ::ApplicationController
  protect_from_forgery

  before_filter :authenticate_user!

  def purge_all_pages
    # Placeholder for feature functionality
  end

  private
    def authorised?
      redirect_to admin_path unless current_user.admin?
    end

    def info_for_paper_trail
      ip = request.remote_ip
      {
        ip: ip
      }
    end

    def paper_trail_enabled_for_controller
      request.user_agent != 'Disable User-Agent'
    end
end
