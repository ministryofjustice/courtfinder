class SearchController < ApplicationController

  def index

    @search = SearchForm.new(params)
    @results = []

    money_claims_aol = AreaOfLaw.where(type_money_claims: true).first

    if params[:area_of_law] == money_claims_aol.name
      @results = Court.where(slug: 'county-court-money-claims-centre-ccmcc')
      @found_in_area_of_law = money_claims_aol
      @errors = nil
      @chosen_area_of_law = money_claims_aol
      @money_claims_court = true

      return
    end

    if params[:area_of_law] == AreaOfLaw.where(type_possession: true).first.name
      @possession_court = true
    end

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
