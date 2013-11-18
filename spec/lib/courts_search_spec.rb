require "spec_helper"

describe CourtSearch do
  before(:each) do
    @court1 = FactoryGirl.create(:court, :name => 'Aylesbury Court', :display => true, :latitude => 51.768305511577, :longitude => -0.57250059493886)
    @court2 = FactoryGirl.create(:court, :name => 'London Court', :display => true)
    @court3 = FactoryGirl.create(:court, :name => 'Reading High Court', :display => true, :latitude => 51.419069727514, :longitude => -0.69702060464972, :areas_of_law => [FactoryGirl.create(:area_of_law, :name => 'Civil')])
    @court4 = FactoryGirl.create(:court, :name => 'Reading Low Court', :display => true, :latitude => 51.419069727514, :longitude => -0.69702060464972, :areas_of_law => [FactoryGirl.create(:area_of_law, :name => 'Family')])
    @court5 = FactoryGirl.create(:court, :name => 'Some Old Court', :display => false)
    @court6 = FactoryGirl.create(:court, :name => 'Yorkshire court', :display => true, :latitude => 54.337246, :longitude => -1.434219)
    20.times { FactoryGirl.create(:court, :name => 'Just one more court', :display => true, :latitude => 51.41906972756, :longitude => -0.69702060464972) }
  end

  it "should return courts nearby if full postcode search" do
    court_search = CourtSearch.new('NE12 8AQ')
    court_search.results.should == [@court6]
  end

  it "should return courts nearby if partial postcode" do
    court_search = CourtSearch.new('NE12')
    court_search.results.should == [@court6]
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
    RestClient::Resource.should_receive(:new).with('http://pclookup.cjs.gov.uk/postcode_finder.php', timeout: 3, open_timeout: 1).once
    CourtSearch.new('irrelevant')
  end

  it "should return an error when the search string is blank" do
    cs = CourtSearch.new('')
    cs.results.should be_empty
    cs.should have(1).errors
  end

  it "should return an error when the postcode cannot be found" do
    cs = CourtSearch.new('irrelevant')
    cs.should_receive(:postcode_search?).and_return(true)
    cs.should_receive(:latlng_from_postcode).and_return(false)
    cs.results.should be_empty
    cs.should have(1).errors
  end

  it "should limit search to a maximum of 20 results" do
    cs = CourtSearch.new('SE1 9NH')
    cs.results.length.should == 20
  end

  context "Chosen area of law is Possession" do
      pending "add some examples"
  end
end
