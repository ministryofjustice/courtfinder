class HomeController < ApplicationController
  def index
    if leaflet_id = params[:court_leaflets_id]
      redirect_to("http://hmctsformfinder.justice.gov.uk/HMCTS/GetLeaflet.do?court_leaflets_id=#{leaflet_id}") && return
    end

    if form_id = params[:court_forms_id]
      redirect_to("http://hmctsformfinder.justice.gov.uk/HMCTS/GetForm.do?court_forms_id=#{form_id}") && return
    end

    if court_id = params[:court_id]
      redirect_to(court_path(Court.find_by_old_id(court_id)), status: 301) && return
    end

    enable_varnish

    @courts = Court.order(:name)
    set_cache_control(@courts.maximum(:updated_at)) && return
    @areas_of_law = AreaOfLaw.has_courts
  end

  alias :index_aol :index

  def api
    
  end
end
