class CourtsController < ApplicationController
  
  respond_to :html, :json

  before_filter :enable_varnish
  before_filter :find_court, except: :index
  before_filter :set_page_expiration, except: :index
  
  def index
    set_cache_control(Court.maximum(:updated_at))
    @courts = Court.by_name
    if params[:compact]
      respond_with @courts.visible.as_json(lookup: true)
    else
      respond_with @courts
    end
    return
  end
  
  def information
    if request.path != information_path(@court, :format => params[:format])
      redirect_to information_path(@court, :format => params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
  end
  
  def defence
    if request.path != defence_path(@court, :format => params[:format])
      redirect_to defence_path(@court, :format => params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
  end
  
  def prosecution
    if request.path != prosecution_path(@court, :format => params[:format])
      redirect_to prosecution_path(@court, :format => params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
  end
  
  def juror
    if request.path != juror_path(@court, :format => params[:format])
      redirect_to juror_path(@court, :format => params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
  end

  def show
    if request.path != court_path(@court, :format => params[:format])
      redirect_to court_path(@court, :format => params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
  end

  private
  def find_court
    @court = Court.find(params[:id])
  end
  
  def set_page_expiration
    set_cache_control(@court.updated_at)
  end
end
