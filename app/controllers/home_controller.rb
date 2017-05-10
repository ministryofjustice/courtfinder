class HomeController < ApplicationController

  before_action :check_area_of_law

  def index
    if params[:court_leaflets_id]
      redirect_to court_leaflet_link
    elsif params[:court_forms_id]
      redirect_to court_form_link
    elsif params[:court_id]
      redirect_to court_path(court), status: 301
    else
      @courts = Court.order(:name)
      @search = SearchForm.new(params)
    end
  end

  alias index_aol index

  def api; end

  protected

  def check_area_of_law
    return if area.blank? || (area.to_param != params[:area_of_law])
    redirect_to area_of_law_landing_path(area), status: 301
  end

  def area
    @area ||= AreaOfLaw.find(params[:area_of_law])
  rescue
    @area = nil
  end

  def hmctsformfinder_link
    'http://hmctsformfinder.justice.gov.uk/HMCTS/'
  end

  def court_leaflet_link
    "#{hmctsformfinder_link}GetLeaflet.do?court_leaflets_id=#{params[:court_leaflets_id]}"
  end

  def court_form_link
    "#{hmctsformfinder_link}GetForm.do?court_forms_id=#{params[:court_forms_id]}"
  end

  def court
    @court ||= Court.find_by(old_id: params[:court_id])
  end
end
