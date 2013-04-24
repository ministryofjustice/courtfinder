class HomeController < ApplicationController
  def index
    @courts = Court.order(:name)
    @court_types = CourtType.order(:name)
    @areas_of_law = AreaOfLaw.order(:name)
  end
end
