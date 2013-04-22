class SearchController < ApplicationController

  def index
    @court_search = CourtSearch.new(params[:q], {:area_of_law => params[:area_of_law]})

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @court_search.results }
    end
  end

end
