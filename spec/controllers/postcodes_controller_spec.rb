require 'spec_helper'

describe PostcodesController do
  describe "GET 'repossession'" do
    it "returns http success" do
      get :repossession, format: :csv
      response.should be_successful
    end
  end

end
