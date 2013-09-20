class SearchController < ApplicationController

  def index
    if params[:area_of_law] == 'Designated money claims'
      redirect_to(court_path('county-court-money-claims-centre'))
      return
    end

    @court_search = CourtSearch.new(@query = params[:q], {:area_of_law => params[:area_of_law]})
    begin
      @results = @court_search.results
      @errors = @court_search.errors
    rescue RestClient::RequestTimeout
      @results = []
      @timeout = true
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @results }
    end
  end

end
