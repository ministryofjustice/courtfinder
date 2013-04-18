class SearchController < ApplicationController

  respond_to :html, :json
  
  def index
    @results = CourtSearch.new(params[:q], {:area_of_law => params[:area_of_law]}).results
    respond_with @results
  end

end
