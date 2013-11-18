class RegionsController < ApplicationController

  before_filter :enable_varnish
  before_filter :set_vary_accept
  respond_to :html, :json

  def index
    @regions = Region.order(:name)
    set_cache_control(@regions.maximum(:updated_at)) && return
    respond_with @regions
  end

  def show
    @region = Region.find(params[:id])
    set_cache_control(@region.updated_at) && return

    if request.path != region_path(@region, :format => params[:format])
      redirect_to region_path(@region, :format => params[:format]), status: :moved_permanently
    else
      respond_with @region
    end
  end
end
