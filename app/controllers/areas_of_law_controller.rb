class AreasOfLawController < ApplicationController

  before_filter :set_vary_header
  respond_to :html, :json

  def index
    @areas_of_law = AreaOfLaw.has_courts
    respond_with @areas_of_law
  end

  def show
    @area_of_law = AreaOfLaw.find(params[:id])

    if request.path != area_of_law_path(@area_of_law, format: params[:format])
      redirect_to area_of_law_path(@area_of_law, format: params[:format]), status: :moved_permanently
    else
      respond_with @area_of_law
    end
  end
end
