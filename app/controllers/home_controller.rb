class HomeController < ApplicationController
  def index
    if leaflet_id = params[:court_leaflets_id]
      redirect_to("http://hmctsformfinder.justice.gov.uk/HMCTS/GetLeaflet.do?court_leaflets_id=#{leaflet_id}")
    end

    if form_id = params[:court_forms_id]
      redirect_to("http://hmctsformfinder.justice.gov.uk/HMCTS/GetForm.do?court_forms_id=#{form_id}")
    end

    if court_id = params[:court_id]
      redirect_to(court_path(Court.find_by_old_id(court_id)))
    end

    @courts = Court.order(:name)
    # @court_types = CourtType.order(:name)
    @areas_of_law = AreaOfLaw.has_courts
  end
end
