require 'spec_helper'

describe HomeController do
  render_views

  before :all do
    @court = Court.create!(old_id: 1, name: "A court of L.A.W.").reload
  end

  context "landing page" do
    it "displays the landing page" do
      controller.should_receive(:enable_varnish)
      controller.should_receive(:set_cache_control).with(@court.updated_at.to_time)
      get :index
      response.should be_success
    end
  end

  context "legacy url redirection" do
    before :each do
      controller.should_receive(:set_cache_control).never
    end

    it "redirects by court_id" do
      get :index, court_id: @court.old_id
      response.should redirect_to(court_path(@court))
    end

    it "redirects to a legacy formfinder leaflet" do
      get :index, court_leaflets_id: 0
      response.should redirect_to("http://hmctsformfinder.justice.gov.uk/HMCTS/GetLeaflet.do?court_leaflets_id=0")
    end

    it "redirects to a legacy formfinder form" do
      get :index, court_forms_id: 0
      response.should redirect_to("http://hmctsformfinder.justice.gov.uk/HMCTS/GetForm.do?court_forms_id=0")
    end
  end
end
