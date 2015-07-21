class HomeController < ApplicationController

  before_filter :check_area_of_law

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

    @courts = Court.order(:name)
    @search = SearchForm.new(params)
  end

  alias :index_aol :index

  def api

  end

  def ping
    @json = File.read("#{Rails.root}/public/ping.json") rescue '{}'
    render json: @json
  end

  protected
    def check_area_of_law
      @area = AreaOfLaw.find(params[:area_of_law]) rescue nil
      redirect_to area_of_law_landing_path(@area), status: 301 unless @area.nil? || (@area.to_param == params[:area_of_law])
    end
end
