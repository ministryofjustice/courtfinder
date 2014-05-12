class SearchController < ApplicationController

  def index
    search_params = params[:court_search] || {}

    if search_params[:area_of_law] == 'Designated money claims'
      redirect_to(court_path('county-court-money-claims-centre'))
      return
    end

    @search = SearchForm.new(search_params)
    @results = []

    if @search.valid?
      begin
        search_results = @search.court_search.results
        @results = search_results.fetch(:courts)
        @found_in_area_of_law = search_results.fetch(:found_in_area_of_law)
        @errors = @search.court_search.errors
        @chosen_area_of_law = AreaOfLaw.find_by_name(@search.area_of_law)
      rescue RestClient::RequestTimeout
        @results = []
        @found_in_area_of_law = 0
        @timeout = true
      end
    else
      render template: '/home/index'
    end
  end

end
