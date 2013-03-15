class SearchController < ApplicationController

  respond_to :html, :json
  
  def index
    @results = CourtSearch.new(params[:q]).results
    respond_with @results
  end

end
