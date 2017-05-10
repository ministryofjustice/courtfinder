class SearchController < ApplicationController
  before_action :load_information

  def index
    respond_to do |format|
      if search.valid?
        load_results
        format.html
        format.json { render json: @results.to_json(include: :addresses) }
      else
        format.html { render template: '/home/index' }
        format.json { render json: @results }
      end
    end
  end

  private

  def money_claims_aol
    AreaOfLaw.where(type_money_claims: true).first
  end

  def search
    @search ||= SearchForm.new(params)
  end

  def load_results
    search_results = search.court_search.results
    @results = search_results.fetch(:courts)
    @found_in_area_of_law = search_results.fetch(:found_in_area_of_law)
    @errors = @search.court_search.errors
    @chosen_area_of_law = AreaOfLaw.find_by(name: search.area_of_law)
  rescue RestClient::RequestTimeout
    null_values_in_case_of_rescue
  end

  def null_values_in_case_of_rescue
    @results = []
    @found_in_area_of_law = 0
    @timeout = true
  end

  def load_claims_center
    if params[:area_of_law] && params[:area_of_law] == money_claims_aol.try(:name)
      @money_claims_centre = Court.where(slug: 'county-court-money-claims-centre-ccmcc').first
    end
  end

  def load_possesion_court
    if params[:area_of_law] == AreaOfLaw.where(type_possession: true).first.try(:name)
      @possession_court = true
    end
  end

  def load_information
    @results = []
    load_claims_center
    load_possesion_court
  end

end
