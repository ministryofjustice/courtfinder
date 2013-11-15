class CourtTypesController < ApplicationController

  before_filter :enable_varnish
  
  respond_to :html, :json

  # GET /court-types
  def index
    set_cache_control(CourtType.maximum(:updated_at)) && return
    @court_types = CourtType.order(:name)
    respond_with @court_types
  end

  # GET /court-types/royal-courts-of-justice
  # GET /court-types/royal-courts-of-justice.json
  def show
    @court_type = CourtType.find(params[:id])
    set_cache_control(@court_type.updated_at) && return

    if request.path != court_type_path(@court_type, :format => params[:format])
      redirect_to court_type_path(@court_type, :format => params[:format]), status: :moved_permanently
    else
      respond_with @court_type
    end
  end
end
