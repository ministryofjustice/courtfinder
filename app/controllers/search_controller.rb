class SearchController < ApplicationController

  respond_to :html, :json
  
  def index
    @court_search = CourtSearch.new(params[:q], {:area_of_law => params[:area_of_law]})
    respond_with @court_search
  end

end
