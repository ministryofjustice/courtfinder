module Admin
  class ApplicationController < ::ApplicationController
    protect_from_forgery

    before_action :authenticate_user!

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

    def render_error_response(format, options)
      if options[:message]
        flash[:error] = options[:message]
      end
      format.html { render action: options[:template] }
      format.json do
        render json: options[:model].errors, status: :unprocessable_entity
      end
    end

  end
end
