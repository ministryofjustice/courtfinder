require "spec_helper"

describe CourtSearch do
  before(:each) do
    @court1 = FactoryGirl.create(:court, :name => 'Aylesbury Court', :display => true, :latitude => 51.768305511577, :longitude => -0.57250059493886)
    @court2 = FactoryGirl.create(:court, :name => 'London Court', :display => true)
    @court3 = FactoryGirl.create(:court, :name => 'Reading High Court', :display => true, :latitude => 51.419069727514, :longitude => -0.69702060464972, :areas_of_law => [FactoryGirl.create(:area_of_law, :name => 'Civil')])
    @court4 = FactoryGirl.create(:court, :name => 'Reading Low Court', :display => true, :latitude => 51.419069727514, :longitude => -0.69702060464972, :areas_of_law => [FactoryGirl.create(:area_of_law, :name => 'Family')])
    @court5 = FactoryGirl.create(:court, :name => 'Some Old Court', :display => false)
  end

  it "should return courts nearby if full postcode search" do
    court_search = CourtSearch.new('hp41du')
    # court_search.stub!(:latlng_from_postcode).and_return([51.768305511577, -0.57250059493886])
    court_search.results.should == [@court1]
  end

  it "should return courts nearby if partial postcode" do
    court_search = CourtSearch.new('hp4')
    # court_search.stub!(:latlng_from_postcode).and_return([51.768305511577, -0.57250059493886])
    court_search.results.should == [@court1]
  end

  it "should not return courts outside of postcode range if postcode search" do
    court_search = CourtSearch.new('e26bh')
    court_search.stub!(:latlng_from_postcode).and_return([51.5274089226, -0.0679536547126])
    court_search.results.should == []
  end

  it "should return courts by name if search is not a postcode" do
    CourtSearch.new('London').results.should == [@court2]
  end

  # it "should return courts by name and court type if both match" do
  #   @court_type = FactoryGirl.create(:court_type, :name => 'London courts')
  #   CourtSearch.new('London').results.should == {:courts => [@court2], :court_types => [@court_type], :areas_of_law => []}
  # end

  # it "should return courts by name and areas of law if both match" do
  #   @area_of_law = FactoryGirl.create(:area_of_law, :name => 'London crime')
  #   CourtSearch.new('London').results.should == {:courts => [@court2], :court_types => [], :areas_of_law => [@area_of_law]}
  # end

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
end
