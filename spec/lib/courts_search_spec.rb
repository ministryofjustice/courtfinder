require "spec_helper"

describe CourtSearch do
  before(:each) do
    @court1 = FactoryGirl.create(:court, :name => 'Aylesbury Court', :latitude => 51.768305511577, :longitude => -0.57250059493886)
    @court2 = FactoryGirl.create(:court, :name => 'London Court')
  end

  it "should return courts nearby if postcode search" do
    court_search = CourtSearch.new('hp41du')
    court_search.stub!(:latlng_from_postcode).and_return([51.768305511577, -0.57250059493886])
    court_search.results.should == {:courts => [@court1], :court_types => [], :areas_of_law => []}
  end

  it "should not return courts outside of postcode range if postcode search" do
    court_search = CourtSearch.new('e26bh')
    court_search.stub!(:latlng_from_postcode).and_return([51.5274089226, -0.0679536547126])
    court_search.results.should == {:courts => [], :court_types => [], :areas_of_law => []}
  end

  it "should return courts by name if search is not a postcode" do
    CourtSearch.new('London').results.should == {:courts => [@court2], :court_types => [], :areas_of_law => []}
  end

  it "should return courts by name and court type if both match" do
    @court_type = FactoryGirl.create(:court_type, :name => 'London courts')
    CourtSearch.new('London').results.should == {:courts => [@court2], :court_types => [@court_type], :areas_of_law => []}
  end

  it "should return courts by name and areas of law if both match" do
    @area_of_law = FactoryGirl.create(:area_of_law, :name => 'London crime')
    CourtSearch.new('London').results.should == {:courts => [@court2], :court_types => [], :areas_of_law => [@area_of_law]}
  end
end