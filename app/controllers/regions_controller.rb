class RegionsController < ApplicationController
  
  respond_to :html, :json

  def index
    @regions = Region.order(:name)
    respond_with @regions
  end

  def show
    @region = Region.find(params[:id])

    if request.path != region_path(@region, :format => params[:format])
      redirect_to region_path(@region, :format => params[:format]), status: :moved_permanently
    else
      respond_with @region
    end
  end
end