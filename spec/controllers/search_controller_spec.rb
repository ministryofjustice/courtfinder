require 'spec_helper'

describe SearchController do
  describe "GET index" do
    it "responds with a list of courts" do
      CourtSearch.any_instance.should_receive(:results).and_return([])
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
  end
end
