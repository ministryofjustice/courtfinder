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

  describe "GET index for children" do
    it "returns a customised message related to children" do
      @court = FactoryGirl.create(:court)
      CourtSearch.any_instance.should_receive(:results).and_return([@court])
      CourtSearch.any_instance.should_receive(:errors).and_return([])
      @area = AreaOfLaw.create(name: 'Children', type_children: true, type_possession: false, type_bankruptcy: false, type_money_claims:false)
      AreaOfLaw.should_receive(:find_by_name).and_return(@area)

      get :index, q: "bs1 6gr", area_of_law: 'Children'
      expect(response).to be_success
      response.body.should include("The court accepts applications related to children for the post code")
    end
  end
end
