class CourtsController < ApplicationController
  
  def index 
    @courts = Court.all
    
    if params[:search]
      @courts = Court.search(params[:search], params[:page], 15)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courts.to_json(:only => [:slug, :name]) }
    end
  end
  
  def show
    @court = Court.find(params[:id])
    if request.path != court_path(@court)
      redirect_to @court, status: :moved_permanently
    end
  end

end
