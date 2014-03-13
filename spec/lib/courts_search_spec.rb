require "spec_helper"
require "courts_spec_helper"

describe CourtSearch do
  before(:each) do
    @at_visiting = FactoryGirl.create(:address_type, :name => "Visiting")    
    @town = FactoryGirl.create(:town, :name => "London")
    @civil = FactoryGirl.create(:area_of_law, :name => 'Civil')
    @family = FactoryGirl.create(:area_of_law, :name => 'Family')

    @visiting_address1 = FactoryGirl.create(:address, :address_line_1 => "Some street", :address_type_id => @at_visiting.id, :postcode => 'NE12 8AQ', :town_id => @town.id)
    @visiting_address2 = FactoryGirl.create(:address, :address_line_1 => "Some street", :address_type_id => @at_visiting.id, :postcode => 'sl58le', :town_id => @town.id)
    @visiting_address3 = FactoryGirl.create(:address, :address_line_1 => "Some street", :address_type_id => @at_visiting.id, :postcode => 'SE19NH', :town_id => @town.id)
    @visiting_address4 = FactoryGirl.create(:address, :address_line_1 => "Some street", :address_type_id => @at_visiting.id, :postcode => 'EH22 4AD', :town_id => @town.id)

    @court1 = FactoryGirl.create(:court, :name => 'Aylesbury Court', :display => true, :address_ids => [@visiting_address3.id])
    @court2 = FactoryGirl.create(:court, :name => 'London Court', :display => true)
    @court3 = FactoryGirl.create(:court, :name => 'Reading High Court', :display => true, 
                                  :area_of_law_ids => [@civil.id], :address_ids => [@visiting_address2.id])

    @court4 = FactoryGirl.create(:court, :name => 'Reading Low Court', :display => true, 
                                :area_of_law_ids => [@family.id], :address_ids => [@visiting_address3.id])

    @court5 = FactoryGirl.create(:court, :name => 'Some Old Court', :display => false)
    @court6 = FactoryGirl.create(:court, :name => 'Yorkshire court', :display => true, :address_ids => [@visiting_address1.id])

    20.times { FactoryGirl.create(:court, :name => 'Just one more court', :display => true, :address_ids => [@visiting_address4.id]) }
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
      cs = CourtSearch.new('EH22 4AD')
      cs.results.length.should == 20
    end
  end

  context "Chosen area of law is Possession" do
    before(:each) do
      @possession = FactoryGirl.create(:area_of_law, :name => 'Possession', :type_possession => true)
      @court7 = FactoryGirl.create(:court, :court_number => 434, :name => 'Possesssions Court', :display => true, 
                                    :area_of_law_ids => [@possession.id], :address_ids => [@visiting_address3.id])

      @court7.postcode_courts.create(:postcode => 'SE19NH')
      # FactoryGirl.create(:postcode_court, :postcode => 'SE19NH', :court_number => @court7.court_number, :court_name => 'Possesssions Court')
      #TODO - Fix these
      @court8 = FactoryGirl.build(:court, :name => 'The Nearest Possesssions Court', :display => true, :areas_of_law => [@possession], :latitude => 54.337246, :longitude => -1.434219)
      @court8.save(:validate => false)

      @court9 = FactoryGirl.build(:court, :name => 'Second Nearest Possesssions Court', :display => true, :areas_of_law => [@possession], :latitude => 54.33724, :longitude => -1.43421)
      @court9.save(:validate => false)
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
      @money_claims = FactoryGirl.create(:area_of_law, name: 'Money Claims', type_money_claims: true)
      #TODO - Fix these
      @court7 = FactoryGirl.build(:court, :court_number => 434, :name => 'Money Claims Courts', :display => true, :areas_of_law => [@money_claims], :latitude => 51.768305511577, :longitude => -0.57250059493886)
      @court7.save(:validate => false)
      @court7.postcode_courts.create(:postcode => 'SE19NH')

      @court8 = FactoryGirl.build(:court, :name => 'The Nearest Money Claims Court', :display => true, :areas_of_law => [@money_claims], :latitude => 54.337246, :longitude => -1.434219)
      @court8.save(:validate => false)

      @court9 = FactoryGirl.build(:court, :name => 'Second Nearest Money Claims Court', :display => true, :areas_of_law => [@money_claims], :latitude => 54.33724, :longitude => -1.43421)
      @court9.save(:validate => false)
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
      @bankruptcy = FactoryGirl.create(:area_of_law, :name => 'Bankruptcy', :type_bankruptcy => true)
      @court7 = FactoryGirl.create(:court, :court_number => 434, :name => 'Bankruptcy Court', :display => true, 
                                    :areas_of_law => [@bankruptcy], :address_ids => [@visiting_address3.id])
      @court7.postcode_courts.create(:postcode => 'SE19NH')
      # FactoryGirl.create(:postcode_court, :postcode => 'SE19NH', :court_number => @court7.court_number, :court_name => 'Possesssions Court')
      @court8 = FactoryGirl.create(:court, :name => 'The Nearest Bankruptcy Court', :display => true, 
                                  :areas_of_law => [@bankruptcy], :address_ids => [@visiting_address1.id])
      @court9 = FactoryGirl.create(:court, :name => 'Second Nearest Bankruptcy Court', :display => true, :areas_of_law => [@bankruptcy], :latitude => 54.33724, :longitude => -1.43421)
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

  context 'With family areas of law' do

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
