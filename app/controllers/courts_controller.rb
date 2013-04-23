class CourtsController < ApplicationController
  
  respond_to :html, :json
  
  def index
    @courts = Court.order(:name)
    respond_with @courts
  end
  
  def show
    @court = Court.find(params[:id])

    if request.path != court_path(@court, :format => params[:format])
      redirect_to court_path(@court, :format => params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
  end
  
end
