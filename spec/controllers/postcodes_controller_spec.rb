require 'spec_helper'

describe PostcodesController do
  describe "GET 'repossession'" do
    let!(:court) { create(:court) }
    let!(:postcode_court) { create(:postcode_court, court: court )}
    
    before do
      get :repossession, format: :csv
    end

    it 'returns http success' do
      response.should be_successful
    end

    it 'returns headings' do
      data = response.body.split("\n")
      data[0].should eq('Post code,Court name,Court number')
    end

    it 'returns correct data' do
      data = response.body.split("\n")
      data[1].should eq([postcode_court.postcode,court.name,court.court_number].join(','))  
    end
  end

end
