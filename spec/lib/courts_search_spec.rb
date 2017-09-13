require "spec_helper"

describe CourtSearch, pending: 'not used anymore' do
  before(:each) do
    @at_visiting = create(:address_type, name: "Visiting")
    @town = create(:town, name: "London")
    @civil = create(:area_of_law, name: 'Civil')
    @family = create(:area_of_law, name: 'Family')

    @visiting_address1 = create(:address, address_line_1: "Some street", address_type_id: @at_visiting.id, postcode: 'NE12 8AQ', town_id: @town.id)
    @visiting_address2 = create(:address, address_line_1: "Some street", address_type_id: @at_visiting.id, postcode: 'sl58le', town_id: @town.id)
    @visiting_address3 = create(:address, address_line_1: "Some street", address_type_id: @at_visiting.id, postcode: 'SE19NH', town_id: @town.id)

    VCR.use_cassette('postcode_found') do
      @court1 = create(:court, name: 'Aylesbury Court', display: true, address_ids: [@visiting_address3.id])
      @court2 = create(:court, name: 'London Court', display: true)
      @court3 = create(:court, name: 'Reading High Court', display: true, area_of_law_ids: [@civil.id], address_ids: [@visiting_address2.id])
      @court4 = create(:court, name: 'Reading Low Court', display: true, area_of_law_ids: [@family.id], address_ids: [@visiting_address3.id])
      @court5 = create(:court, name: 'Some Old Court', display: false)
    end

  end

  context "postcode search" do
    let!(:at_visiting) { create(:address_type, name: "Visiting") }
    let!(:town) { create(:town, name: "London") }

    let!(:visiting_address1) { create(:address, address_line_1: "Some street", address_type_id: at_visiting.id, postcode: 'NE12 8AQ', town_id: town.id) }
    let!(:court6) do
      VCR.use_cassette('postcode_found') do
        create(:court, name: 'Yorkshire court', display: true, address_ids: [visiting_address1.id])
      end
    end

    xit "should return courts nearby if full postcode search" do
      VCR.use_cassette('postcode_found') do
        court_search = CourtSearch.new('NE12 8AQ')
        expect(court_search.results.fetch(:found_in_area_of_law)).to eq 0
        court_search.results.fetch(:courts).should == [court6]
      end
    end

    xit "should return courts nearby if partial postcode" do
      VCR.use_cassette('partial_postcode') do
        court_search = CourtSearch.new('NE12')
        expect(court_search.results.fetch(:found_in_area_of_law)).to eq 0
        court_search.results.fetch(:courts).should == [court6]
      end
    end

    context "when local mapit server request fails" do
      local_url = "http://mapit.service.dsd.io/postcode/EC1V+7DP"
      mapit_url = "http://mapit.mysociety.org/postcode/EC1V+7DP"

      headers = { 'Accept' => '*/*; q=0.5, application/xml', 'Accept-Encoding' => 'gzip, deflate', 'User-Agent' => 'Ruby' }

      xit "should fallback to the remote mapit api" do
        pending
        stub_request(:get, local_url).with(headers: headers).to_return(status: 500, body: "", headers: {})
        stub_request(:get, mapit_url).with(headers: headers).to_return(status: 200, body: '{}', headers: {})

        CourtSearch.new('EC1V 7DP').results

        a_request(:get, local_url).should have_been_made.once
        a_request(:get, mapit_url).should have_been_made.once
      end
    end
  end

  xit "should return courts by name if search is not a postcode" do
    court_search_london = CourtSearch.new('London')
    expect(court_search_london.results.fetch(:found_in_area_of_law)).to eq 0
    court_search_london.results.fetch(:courts).should == [@court2]
  end

  xit "should limit results to area of law when specified" do
    court_search_london = CourtSearch.new('Reading', area_of_law: 'Civil')
    expect(court_search_london.results.fetch(:found_in_area_of_law)).to eq 0
    court_search_london.results.fetch(:courts).should == [@court3]
  end

  xit "should return courts nearby for postcodes limited to area of law" do
    court_search = CourtSearch.new('sl58le', area_of_law: 'Civil')
    allow(court_search).to receive(:latlng_from_postcode).and_return([51.419069727514, -0.69702060464972])
    expect(court_search.results.fetch(:found_in_area_of_law)).to be > 0
    court_search.results.fetch(:courts).should == [@court3]
  end

  xit "should return not show courts which are closed" do
    court_search = CourtSearch.new('court')
    court_search.results.should_not include(@court5)
  end

  xit "should propagate exceptions to the controller" do
    RestClient::Resource.any_instance.should_receive(:get).and_raise(StandardError)
    expect do
      CourtSearch.new('EC1M 5UQ').results
    end.to raise_error(StandardError)
  end

  xit "should get initialized with proper timeout values" do
    pending
    RestClient::Resource.should_receive(:new).with('http://mapit.service.dsd.io/postcode', timeout: 3, open_timeout: 1).once
    CourtSearch.new('irrelevant')
  end

  xit "should return an error when the search string is blank" do
    VCR.use_cassette('postcode_not_found') do
      cs = CourtSearch.new('')
      cs.results.fetch(:courts).should be_empty
      cs.should have(1).errors
    end
  end

  xit "should return an error when the postcode cannot be found" do
    VCR.use_cassette('postcode_not_found') do
      cs = CourtSearch.new('irrelevant')
      cs.should_receive(:postcode_search?).and_return(true)
      cs.should_receive(:latlng_from_postcode).and_return(false)
      cs.results.fetch(:courts).should be_empty
      cs.should have(1).errors
    end
  end

  xit "should return an error when the postcode cannot be found for a partial postcode" do
    VCR.use_cassette('postcode_not_found') do
      cs = CourtSearch.new('YO6')
      cs.results.fetch(:courts).should be_empty
      cs.should have(1).errors
    end
  end

  xit "should return an error when the postcode cannot be found for a complete postcode" do
    VCR.use_cassette('postcode_not_found') do
      cs = CourtSearch.new('T27 4DB')
      cs.results.fetch(:courts).should be_empty
      cs.should have(1).errors
    end
  end

  context "search results limit" do
    let!(:at_visiting) { create(:address_type, name: "Visiting") }
    let!(:town) { create(:town, name: "London") }

    let!(:visiting_address) do
      create(:address, address_line_1: "Some street",
                       address_type_id: at_visiting.id, postcode: 'EH22 4AD', town_id: town.id)
    end

    xit "should limit search to a maximum of 20 results" do
      VCR.use_cassette('postcode_found') do
        20.times { create(:court, name: 'Just one more court', display: true, address_ids: [visiting_address.id]) }

        cs = CourtSearch.new('EH22 4AD')
        cs.results.fetch(:courts).length.should == 20
      end
    end
  end

  context "Chosen area of law is Possession" do
    before(:each) do
      @possession = create(:area_of_law, name: 'Possession', type_possession: true)
      VCR.use_cassette('postcode_found') do
        @court7 = create(:court, court_number: 434, name: 'Possesssions Court', display: true,
                                 area_of_law_ids: [@possession.id], address_ids: [@visiting_address3.id])
      end
      @court7.postcode_courts.create(postcode: 'SE19NH')
      VCR.use_cassette('postcode_found') do
        @court8 = create(:court, name: 'The Nearest Possesssions Court', display: true, areas_of_law: [@possession],
                                 address_ids: [@visiting_address1.id])
      end
    end

    xit "should return only one search result if the postcode is found in the Postcode to court mapping" do
      VCR.use_cassette('postcode_found') do
        court_search = CourtSearch.new('SE19NH', area_of_law: 'Possession')
        expect(court_search.results.fetch(:found_in_area_of_law)).to be > 0
        court_search.results.fetch(:courts).should == [@court7]
      end
    end

    xit "if the postcode is not found in the Postcode to court mapping, then just default to distance search, but return only the nearest one court" do
      VCR.use_cassette('postcode_found') do
        court_search = CourtSearch.new('NE128AQ', area_of_law: 'Possession')
        expect(court_search.results.fetch(:found_in_area_of_law)).to eq 1
        court_search.results.fetch(:courts).should == [@court8]
      end
    end
  end

  context "Chosen area of law is Money Claims" do
    before(:each) do
      @money_claims = create(:area_of_law, name: 'Money Claims', type_money_claims: true)
      # TODO: - Fix these
      VCR.use_cassette('postcode_found') do
        @court7 = create(:court, court_number: 434, name: 'Money Claims Court', display: true,
                                 area_of_law_ids: [@money_claims.id], address_ids: [@visiting_address3.id])
        @court8 = create(:court, name: 'The Nearest Money Claims Court', display: true, areas_of_law: [@money_claims],
                                 address_ids: [@visiting_address1.id])

      end

      # @court7 = build(:court, :court_number => 434, :name => 'Money Claims Courts', :display => true, :areas_of_law => [@money_claims], :latitude => 51.768305511577, :longitude => -0.57250059493886)
      # @court7.save(:validate => false)
      @court7.postcode_courts.create(postcode: 'SE19NH')

      # @court8 = build(:court, :name => 'The Nearest Money Claims Court', :display => true, :areas_of_law => [@money_claims], :latitude => 54.337246, :longitude => -1.434219)
      # @court8.save(:validate => false)
    end

    xit "should return only one search result if the postcode is found in the postcode to court mapping" do
      VCR.use_cassette('postcode_found') do
        court_search = CourtSearch.new('SE19NH', area_of_law: 'Money Claims')
        expect(court_search.results.fetch(:found_in_area_of_law)).to eq 1
        court_search.results.fetch(:courts).should == [@court7]
      end
    end

    xit "if the postcode is not found in the postcode to court mapping, then just default to distance search, but return only the nearest one court" do
      VCR.use_cassette('postcode_found') do
        court_search = CourtSearch.new('NE128AQ', area_of_law: 'Money Claims')
        expect(court_search.results.fetch(:found_in_area_of_law)).to eq 1
        court_search.results.fetch(:courts).should == [@court8]
      end
    end
  end

  context "Chosen area of law is Bankruptcy" do
    before(:each) do
      @bankruptcy = create(:area_of_law, name: 'Bankruptcy', type_bankruptcy: true)
      VCR.use_cassette('postcode_found') do
        @court7 = create(:court, court_number: 434, name: 'Bankruptcy Court', display: true,
                                 areas_of_law: [@bankruptcy], address_ids: [@visiting_address3.id])
        @court7.postcode_courts.create(postcode: 'SE19NH')
        # create(:postcode_court, :postcode => 'SE19NH', :court_number => @court7.court_number, :court_name => 'Possesssions Court')
        @court8 = create(:court, name: 'The Nearest Bankruptcy Court', display: true,
                                 areas_of_law: [@bankruptcy], address_ids: [@visiting_address1.id])
      end
    end

    xit "should return only one search result if the postcode is found in the Postcode to court mapping" do
      VCR.use_cassette('postcode_found') do
        court_search = CourtSearch.new('SE19NH', area_of_law: 'Bankruptcy')
        expect(court_search.results.fetch(:found_in_area_of_law)).to eq 1
        court_search.results.fetch(:courts).should == [@court7]
      end
    end

    xit "if the postcode is not found in the Postcode to court mapping, then just default to distance search, but return only the nearest one court" do
      VCR.use_cassette('postcode_not_found') do
        court_search = CourtSearch.new('NE128AQ', area_of_law: 'Bankruptcy')
        expect(court_search.results.fetch(:found_in_area_of_law)).to eq 1
        court_search.results.fetch(:courts).should == [@court8]
      end
    end
  end

  context "Finding local authority name from postcode" do
    context "when the local authority is located in shortcuts/council/county" do
      xit 'should return the name of the local authority for a postcode' do
        VCR.use_cassette('postcode_found') do
          court_search = CourtSearch.new('EX1 1UH')
          court_search.latlng_from_postcode('EX1 1UH')
          expect(court_search.lookup_local_authority_name).to eq 'Devon County Council'
        end
      end
    end

    context "when the local authority is located in shortcuts/council" do
      xit 'should return the name of the local authority for a postcode' do
        VCR.use_cassette('postcode_found') do
          court_search = CourtSearch.new('SE24 0NG')
          court_search.latlng_from_postcode('SE24 0NG')
          expect(court_search.lookup_local_authority_name).to eq 'Lambeth Borough Council'
        end
      end
    end

    context 'when the postcode is invalid' do
      xit 'should return nil for a partial postcode' do
        VCR.use_cassette('partial_postcode') do
          court_search = CourtSearch.new('EX1')
          expect(court_search.lookup_local_authority_name).to be_nil
        end
      end

      xit 'should return nil for a wrong postcode' do
        VCR.use_cassette('postcode_not_found') do
          court_search = CourtSearch.new('invalid')
          expect(court_search.lookup_local_authority_name).to be_nil
        end
      end
    end
  end

  context 'With family areas of law' do
    before { skip 'not needed anymore' }

    describe 'Children' do
      it_should_behave_like 'a search with area of law', 'Children'
    end

    describe 'Divorce' do
      it_should_behave_like 'a search with area of law', 'Divorce'
    end

    describe 'Adoption' do
      it_should_behave_like 'a search with area of law', 'Adoption'
    end
  end
end
