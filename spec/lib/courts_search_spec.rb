require "spec_helper"

describe CourtSearch do
  before(:each) do
    @court1 = create(:court, :name => 'Aylesbury Court', :display => true, :latitude => 51.768305511577, :longitude => -0.57250059493886)
    @court2 = create(:court, :name => 'London Court', :display => true)
    @court3 = create(:court, :name => 'Reading High Court', :display => true, :latitude => 51.419069727514, :longitude => -0.69702060464972, :areas_of_law => [create(:area_of_law, :name => 'Civil')])
    @court4 = create(:court, :name => 'Reading Low Court', :display => true, :latitude => 51.419069727514, :longitude => -0.69702060464972, :areas_of_law => [create(:area_of_law, :name => 'Family')])
    @court5 = create(:court, :name => 'Some Old Court', :display => false)
    @court6 = create(:court, :name => 'Yorkshire court', :display => true, :latitude => 54.337246, :longitude => -1.434219)
    20.times { create(:court, :name => 'Just one more court', :display => true, :latitude => 51.41906972756, :longitude => -0.69702060464972) }
  end

  it "should return courts nearby if full postcode search" do
    VCR.use_cassette('postcode_found') do
      court_search = CourtSearch.new('NE12 8AQ')
      court_search.results.should == [@court6]
    end
  end

  it "should return courts nearby if partial postcode" do
    VCR.use_cassette('partial_postcode') do
      court_search = CourtSearch.new('NE12')
      court_search.results.should == [@court6]
    end
  end

  it "should return courts by name if search is not a postcode" do
    CourtSearch.new('London').results.should == [@court2]
  end

  it "should limit results to area of law when specified" do
    # should return court 3 and not court 4
    CourtSearch.new('Reading', {:area_of_law => 'Civil'}).results.should == [@court3]
  end

  it "should return courts nearby for postcodes limited to area of law" do
    court_search = CourtSearch.new('sl58le', {:area_of_law => 'Civil'})
    court_search.stub!(:latlng_from_postcode).and_return([51.419069727514, -0.69702060464972])
    court_search.results.should == [@court3]
  end

  it "should return not show courts which are closed" do
    court_search = CourtSearch.new('court')
    court_search.results.should_not include(@court5)
  end

  it "should propagate exceptions to the controller" do
    RestClient::Resource.any_instance.should_receive(:get).and_raise(StandardError)
    expect {
      CourtSearch.new('EC1M 5UQ').results
    }.to raise_error(StandardError)
  end

  it "should get initialized with proper timeout values" do
    RestClient::Resource.should_receive(:new).with('http://mapit.mysociety.org/postcode', timeout: 3, open_timeout: 1).once
    CourtSearch.new('irrelevant')
  end

  it "should return an error when the search string is blank" do
    VCR.use_cassette('postcode_not_found') do
      cs = CourtSearch.new('')
      cs.results.should be_empty
      cs.should have(1).errors
    end
  end

  it "should return an error when the postcode cannot be found" do
    VCR.use_cassette('postcode_not_found') do
      cs = CourtSearch.new('irrelevant')
      cs.should_receive(:postcode_search?).and_return(true)
      cs.should_receive(:latlng_from_postcode).and_return(false)
      cs.results.should be_empty
      cs.should have(1).errors
    end
  end

  it "should return an error when the postcode cannot be found for a partial postcode" do
    VCR.use_cassette('postcode_not_found') do
      cs = CourtSearch.new('YO6')
      cs.results.should be_empty
      cs.should have(1).errors
    end
  end

  it "should return an error when the postcode cannot be found for a complete postcode" do
    VCR.use_cassette('postcode_not_found') do
      cs = CourtSearch.new('T27 4DB')
      cs.results.should be_empty
      cs.should have(1).errors
    end
  end

  it "should limit search to a maximum of 20 results" do
    VCR.use_cassette('postcode_found') do
      cs = CourtSearch.new('SE1 9NH')
      cs.results.length.should == 20
    end
  end

  context "Chosen area of law is Possession" do
    before(:each) do
      @possession = create(:area_of_law, :name => 'Possession', :type_possession => true)
      @court7 = create(:court, :court_number => 434, :name => 'Possesssions Court', :display => true, :areas_of_law => [@possession], :latitude => 51.768305511577, :longitude => -0.57250059493886)
      @court7.postcode_courts.create(:postcode => 'SE19NH')
      # create(:postcode_court, :postcode => 'SE19NH', :court_number => @court7.court_number, :court_name => 'Possesssions Court')
      @court8 = create(:court, :name => 'The Nearest Possesssions Court', :display => true, :areas_of_law => [@possession], :latitude => 54.337246, :longitude => -1.434219)
      @court9 = create(:court, :name => 'Second Nearest Possesssions Court', :display => true, :areas_of_law => [@possession], :latitude => 54.33724, :longitude => -1.43421)
    end

    it "should return only one search result if the postcode is found in the Postcode to court mapping" do
      VCR.use_cassette('postcode_found') do
        court_search = CourtSearch.new('SE19NH', {:area_of_law => 'Possession'})
        court_search.results.should == [@court7]
      end
    end

    it "if the postcode is not found in the Postcode to court mapping, then just default to distance search, but return only the nearest one court" do
      VCR.use_cassette('postcode_found') do
        court_search = CourtSearch.new('NE128AQ', {:area_of_law => 'Possession'})
        court_search.results.should == [@court8]
      end
    end
  end

  context "Chosen area of law is Money Claims" do
    before(:each) do
      @money_claims = create(:area_of_law, name: 'Money Claims', type_money_claims: true)
      @court7 = create(:court, :court_number => 434, :name => 'Money Claims Courts', :display => true, :areas_of_law => [@money_claims], :latitude => 51.768305511577, :longitude => -0.57250059493886)
      @court7.postcode_courts.create(:postcode => 'SE19NH')
      @court8 = create(:court, :name => 'The Nearest Money Claims Court', :display => true, :areas_of_law => [@money_claims], :latitude => 54.337246, :longitude => -1.434219)
      @court9 = create(:court, :name => 'Second Nearest Money Claims Court', :display => true, :areas_of_law => [@money_claims], :latitude => 54.33724, :longitude => -1.43421)
    end

    it "should return only one search result if the postcode is found in the postcode to court mapping" do
      VCR.use_cassette('postcode_found') do
        court_search = CourtSearch.new('SE19NH', {:area_of_law => 'Money Claims'})
        court_search.results.should == [@court7]
      end
    end

    it "if the postcode is not found in the postcode to court mapping, then just default to distance search, but return only the nearest one court" do
      VCR.use_cassette('postcode_found') do
        court_search = CourtSearch.new('NE128AQ', {:area_of_law => 'Money Claims'})
        court_search.results.should == [@court8]
      end
    end
  end

  context "Chosen area of law is Bankruptcy" do
    before(:each) do
      @bankruptcy = create(:area_of_law, :name => 'Bankruptcy', :type_bankruptcy => true)
      @court7 = create(:court, :court_number => 434, :name => 'Bankruptcy Court', :display => true, :areas_of_law => [@bankruptcy], :latitude => 51.768305511577, :longitude => -0.57250059493886)
      @court7.postcode_courts.create(:postcode => 'SE19NH')
      # create(:postcode_court, :postcode => 'SE19NH', :court_number => @court7.court_number, :court_name => 'Possesssions Court')
      @court8 = create(:court, :name => 'The Nearest Bankruptcy Court', :display => true, :areas_of_law => [@bankruptcy], :latitude => 54.337246, :longitude => -1.434219)
      @court9 = create(:court, :name => 'Second Nearest Bankruptcy Court', :display => true, :areas_of_law => [@bankruptcy], :latitude => 54.33724, :longitude => -1.43421)
    end

    it "should return only one search result if the postcode is found in the Postcode to court mapping" do
      VCR.use_cassette('postcode_found') do
        court_search = CourtSearch.new('SE19NH', {:area_of_law => 'Bankruptcy'})
        court_search.results.should == [@court7]
      end
    end

    it "if the postcode is not found in the Postcode to court mapping, then just default to distance search, but return only the nearest one court" do
      VCR.use_cassette('postcode_not_found') do
        court_search = CourtSearch.new('NE128AQ', {:area_of_law => 'Bankruptcy'})
        court_search.results.should == [@court8]
      end
    end
  end

  context "Finding Council name from postcode" do
    context "when the council is located in shortcuts/council/county" do
      it 'should return the name of the council for a postcode' do
        VCR.use_cassette('postcode_found') do
          court_search = CourtSearch.new('EX1 1UH')
          expect(court_search.lookup_council_name).to eq 'Devon County Council'
        end
      end
    end

    context "when the council is located in shortcuts/council" do
      it 'should return the name of the council for a postcode' do
        VCR.use_cassette('postcode_found') do
          court_search = CourtSearch.new('SE24 0NG')
          expect(court_search.lookup_council_name).to eq 'Lambeth Borough Council'
        end
      end
    end

    context 'when the postcode is invalid' do
      it 'should return nil for a partial postcode' do
        VCR.use_cassette('partial_postcode') do
          court_search = CourtSearch.new('EX1')
          expect(court_search.lookup_council_name).to be_nil
        end
      end

      it 'should return nil for a wrong postcode' do
        VCR.use_cassette('postcode_not_found') do
          court_search = CourtSearch.new('invalid')
          expect(court_search.lookup_council_name).to be_nil
        end
      end
    end
  end

  ['Children','Divorce','Adoption'].each do |area|

    context "Chosen area of law is #{area}" do
      let!(:area_of_law) { create(:area_of_law, name: area, "type_#{area.downcase}" => true)}
      # Location: http://mapit.mysociety.org/nearest/4326/-0.110768,51449126: SW2 2YH (Inside the Lambeth Borough Council)
      let!(:court7) { create(:court, court_number: 434, name: "#{area} Court A", display: true, areas_of_law: [area_of_law], latitude: 51.449126, longitude: -0.110768) }
      # Location: http://mapit.mysociety.org/nearest/4326/-0.099868,51451707: SE24 9HN (Southwark Borough Council)
      let!(:court8) { create(:court, name: "The Nearest #{area} Court - Southwark Borough Council", display: true, areas_of_law: [area_of_law], latitude: 51.451707, longitude: -0.099868) }
      let!(:council) { Council.create(name: 'Lambeth Borough Council') }

      it "should return only one search result if the postcode is found in the Postcode to court mapping" do
        RestClient.log = "#{Rails.root}/log/mapit_postcodes.log"
        # Location: http://mapit.mysociety.org/point/4326/-0.103709,51.452335 => SE24 0NG (Inside the Lambeth Borough Council)
        VCR.use_cassette('postcode_found') do
          court_search = CourtSearch.new('SE240NG', {:area_of_law => 'Children'})
          expect(court_search.results).to eq [@court7]
        end
      end

      before(:each) do
        court7.court_council_links.create({council_id: council.id, area_of_law_id: area_of_law.id})
      end

      it "should return only one search result if the postcode is found in the Postcode to court mapping" do
        RestClient.log = "#{Rails.root}/log/mapit_postcodes.log"
        # Location: http://mapit.mysociety.org/point/4326/-0.103709,51.452335 => SE24 0NG (Inside the Lambeth Borough Council)
        VCR.use_cassette('postcode_found') do
          court_search = CourtSearch.new('SE240NG', { area_of_law: area})
          expect(court_search.results).to eq [court7]
        end
      end

      context 'when there are multiple courts' do
        # Location:51.451373,-0.106004 (Inside the Lambeth Borough Council)
        let(:court9) { create(:court, court_number: 435, name: "#{area} Court B", display: true, areas_of_law: [area_of_law], latitude: 51.451373, longitude: -0.106004) }
        
        it 'should return multiple courts sorted by distance' do
          court9.court_council_links.create.update_attributes({council_id: council.id, area_of_law_id: area_of_law.id})
          VCR.use_cassette('multiple_courts') do
            court_search = CourtSearch.new('SE240NG', {area_of_law: area})
            results = court_search.results
            expect(results).to eq [court9, court7]
            expect(results[0].distance).to eq "0.16110282696898"
            expect(results[1].distance).to eq "0.418361404378377"
          end
        end
      end

      it "if the postcode is not found in the Postcode to court mapping, then just default to distance search" do
        @court10 = create(:court, name: 'The Nearest Court', display: true, areas_of_law: [area_of_law], latitude: 54.337246, longitude: -1.434219)
        @court11 = create(:court, name: 'Second Nearest Court', display: true, areas_of_law: [area_of_law], latitude: 54.33724, longitude: -1.43421)
        VCR.use_cassette('postcode_not_found') do
          court_search = CourtSearch.new('NE128AQ', {area_of_law: area})
          court_search.results.should == [@court10, @court11]
        end
      end
    end
  end

end
