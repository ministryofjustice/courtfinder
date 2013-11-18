require 'spec_helper'

describe SearchController do
  render_views

  describe "GET index" do
    it "responds with a list of courts" do
      CourtSearch.any_instance.should_receive(:results).and_return([])
      get :index
      response.should be_success
    end

    it "doesn't blow up when results are nil" do 
      CourtSearch.any_instance.should_receive(:results).and_return(nil)
      get :index
      response.should be_success
    end

    it "responds with an error message when there's a timeout" do
      CourtSearch.any_instance.should_receive(:results).and_raise(RestClient::RequestTimeout)
      get :index
      response.should be_success
    end

    it "responds with a generic error message when something else's wrong" do
      CourtSearch.any_instance.should_receive(:results).and_raise(StandardError)
      expect {
        get :index
      }.to raise_error(StandardError)
    end

    it "redirects to CCMCC if we're dealing with a money claim for any postcode" do
      get :index, area_of_law: 'Designated money claims', q: ''
      response.should redirect_to('/courts/county-court-money-claims-centre')
    end
  end


  describe "GET index (json)" do
    
    before :each do
      @court = FactoryGirl.create(:court)
    end

    it "responds with a bad request if there's no search term" do
      get :index, format: :json
      response.status.should == 400
    end

    it "returns a list of courts as a json array" do
      get :index, format: :json, q: 'court'
      response.should be_success
      response.content_type.should == 'application/json'
      JSON.parse(response.body).should == [{"@id" => court_path(@court), "name" => @court.name}]
    end
  end

end
