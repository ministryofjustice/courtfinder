require 'spec_helper'

describe SearchController do
  render_views

  describe "GET index" do

    before do
      SearchForm.any_instance.stub(:valid?).and_return(true)
    end

    it "responds with a hash with the count of area(s) of law found and list of courts" do
      CourtSearch.any_instance.should_receive(:results).and_return({found_in_area_of_law: 1, courts: [] })
      get :index
      response.should be_success
    end

    it "handles nil results gracefully" do
      CourtSearch.any_instance.should_receive(:results).and_return({found_in_area_of_law: 0, courts: nil })
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
      get :index, { area_of_law: 'Designated money claims', q: '' }
      response.should redirect_to('/courts/county-court-money-claims-centre')
    end
  end

  describe "GET index for children" do
    let!(:court) { create(:court) }

    it "returns a customised message related to children" do
      CourtSearch.any_instance.stub(:results).and_return({found_in_area_of_law: 2, courts: Array.new(2, court)})
      CourtSearch.any_instance.stub(:errors).and_return([])

      @area = AreaOfLaw.create(name: 'Children', type_children: true, type_possession: false, type_bankruptcy: false, type_money_claims:false)
      AreaOfLaw.should_receive(:find_by_name).and_return(@area)

      get :index, q: "bs1 6gr", area_of_law: 'Children'
      expect(response).to be_success
      response.body.should include("Courts dealing with applications involving children for")
    end

    it "returns the standard message when the found_in_area_of_law is more than 0" do
      CourtSearch.any_instance.stub(:results).and_return({found_in_area_of_law: 6, courts:Array.new(6, court)})
      CourtSearch.any_instance.stub(:errors).and_return(['no exact match'])

      @area = AreaOfLaw.create(name: 'Children', type_children: true, type_possession: false, type_bankruptcy: false, type_money_claims:false)
      AreaOfLaw.should_receive(:find_by_name).and_return(@area)

      get :index, q: 'bs1 6gr', area_of_law: 'Children'
      expect(response).to be_success
      response.body.should include("Courts dealing with applications involving children for")
    end

  end
end
