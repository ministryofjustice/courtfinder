class SearchController < ApplicationController

  def index

    @search = SearchForm.new(params)
    @results = []

    money_claims_aol = AreaOfLaw.where(type_money_claims: true).first

    if params[:area_of_law] && params[:area_of_law] == money_claims_aol.try(:name)
      @money_claims_centre = Court.where(slug: 'county-court-money-claims-centre-ccmcc').first
    end

    if params[:area_of_law] == AreaOfLaw.where(type_possession: true).first.try(:name)
      @possession_court = true
    end

    if @search.valid?
      begin
        search_results = @search.court_search.results
        @results = search_results.fetch(:courts)
        @found_in_area_of_law = search_results.fetch(:found_in_area_of_law)
        @errors = @search.court_search.errors
        @chosen_area_of_law = AreaOfLaw.find_by_name(@search.area_of_law)
       respond_to do |format|
          format.html
          format.json { render json: @results.to_json(include: :addresses) }
        end
      rescue RestClient::RequestTimeout
        @results = []
        @found_in_area_of_law = 0
        @timeout = true
      end
    else
     respond_to do |format|
        format.html { render template: '/home/index' }
        format.json { render json: @results }
      end
    end
  end
end
