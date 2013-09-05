require 'spec_helper'

describe HomeController do
  render_views
  
  context "landing page" do
    before :each do
      controller.should_receive(:set_page_expiration)
    end

    it "displays the landing page" do
      get :index
      response.should be_success
    end
  end

  context "legacy url redirection" do
    it "redirects by court_id" do
      court = Court.create!(old_id: 1, name: "A court of L.A.W.")
      get :index, court_id: court.old_id
      response.should redirect_to(court_path(court))
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
