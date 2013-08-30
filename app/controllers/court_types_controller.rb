class CourtTypesController < ApplicationController

  before_filter :set_page_expiration
  
  respond_to :html, :json

  # GET /court-types
  def index
    @court_types = CourtType.order(:name)
    respond_with @court_types
  end

  # GET /court-types/royal-courts-of-justice
  # GET /court-types/royal-courts-of-justice.json
  def show
    @court_type = CourtType.find(params[:id])

    if request.path != court_type_path(@court_type, :format => params[:format])
      redirect_to court_type_path(@court_type, :format => params[:format]), status: :moved_permanently
    else
      respond_with @court_type
    end
  end
end
