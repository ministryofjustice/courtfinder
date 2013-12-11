require 'spec_helper'

describe HomeController do
  render_views

  before :each do
    @court = Court.create!(old_id: 1, name: "A court of L.A.W.").reload
  end

  context "landing page" do
    it "displays the landing page" do
      controller.should_receive(:enable_varnish).twice
      controller.should_receive(:set_cache_control).with(@court.updated_at.to_time).twice.and_call_original
      get :index
      response.should be_success

      request.env['HTTP_IF_MODIFIED_SINCE'] = response['Last-Modified']
      get :index
      response.status.should == 304
    end
  end

  context "legacy url redirection" do
    before :each do
      controller.should_receive(:set_cache_control).never
      controller.should_receive(:enable_varnish).never
    end

    it "redirects by court_id" do
      get :index, court_id: @court.old_id
      response.should redirect_to(court_path(@court))
      response.status.should == 301
    end

    it "redirects to a legacy formfinder leaflet" do
      get :index, court_leaflets_id: 0
      response.should redirect_to("http://hmctsformfinder.justice.gov.uk/HMCTS/GetLeaflet.do?court_leaflets_id=0")
      response.status.should == 302
    end

    it "redirects to a legacy formfinder form" do
      get :index, court_forms_id: 0
      response.should redirect_to("http://hmctsformfinder.justice.gov.uk/HMCTS/GetForm.do?court_forms_id=0")
      response.status.should == 302
    end
  end
end
