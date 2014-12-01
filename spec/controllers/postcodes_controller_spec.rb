require 'spec_helper'

describe PostcodesController do
  pending 'is this controller even used anymore?'
  
  describe "GET 'repossession'" do
    let!(:court) { create(:court, cci_code: 10) }
    let!(:postcode_court) { create(:postcode_court, court: court )}

    it 'returns http success' do
      get :repossession, format: :csv

      response.should be_successful
    end

    it 'returns headings' do
      get :repossession, format: :csv

      data = response.body.split("\n")
      data[0].should eq('Post code,Court URL,Court name,Court number')
    end

    it 'returns correct data' do
      get :repossession, format: :csv

      data = response.body.split("\n")
      data[1].should eq([postcode_court.postcode,court_path(court),court.name,court.cci_code].join(','))  
    end

    it 'returns a question mark for no cci_number' do
      court.update_attribute(:cci_code, nil)
      get :repossession, format: :csv

      data = response.body.split("\n")
      data[1].last.should eq('?')  
    end
  end

end
