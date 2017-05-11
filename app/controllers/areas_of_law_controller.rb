class AreasOfLawController < ApplicationController

  before_action :set_vary_header
  respond_to :html, :json

  def index
    @areas_of_law = AreaOfLaw.has_courts
    respond_with @areas_of_law
  end

  def show
    @area_of_law = AreaOfLaw.find(params[:id])

    if request.path != are_of_law_link
      redirect_to are_of_law_link, status: :moved_permanently
    else
      respond_with @area_of_law
    end
  end

  private

  def are_of_law_link
    area_of_law_path(@area_of_law, format: params[:format])
  end
end
