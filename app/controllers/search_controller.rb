class SearchController < ApplicationController

  def index
    if params[:area_of_law] == 'Designated money claims'
      redirect_to(court_path('county-court-money-claims-centre'))
      return
    end

    @court_search = CourtSearch.new(@query = params[:q], {:area_of_law => params[:area_of_law]})
    begin
      search_results = @court_search.results
      @results = search_results.fetch(:courts)
      @found_in_area_of_law = search_results.fetch(:found_in_area_of_law)
      @errors = @court_search.errors
      @chosen_area_of_law = AreaOfLaw.find_by_name(params[:area_of_law])
    rescue RestClient::RequestTimeout
      @results = []
      @found_in_area_of_law = 0
      @timeout = true
    end

    respond_to do |format|
      format.html
      format.json do
        if @errors.any?
          head :bad_request and return
        end
      end
    end
  end

end
