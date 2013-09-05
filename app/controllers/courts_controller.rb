class CourtsController < ApplicationController
  
  respond_to :html, :json

  before_filter :set_page_expiration
  
  def index
    @courts = Court.by_name
    respond_with @courts
  end
  
  def information
    @court = Court.find(params[:id])

    if request.path != information_path(@court, :format => params[:format])
      redirect_to information_path(@court, :format => params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
  end
  
  def defence
    @court = Court.find(params[:id])

    if request.path != defence_path(@court, :format => params[:format])
      redirect_to defence_path(@court, :format => params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
  end
  
  def prosecution
    @court = Court.find(params[:id])

    if request.path != prosecution_path(@court, :format => params[:format])
      redirect_to prosecution_path(@court, :format => params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
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
