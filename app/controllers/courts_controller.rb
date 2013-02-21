class CourtsController < ApplicationController
  def index 
	@courts = Court.all
  end
  def show
	@court = Court.find(params[:id])
	if request.path != court_path(@court)
		redirect_to @court, status: :moved_permanently
	end
  end
end
