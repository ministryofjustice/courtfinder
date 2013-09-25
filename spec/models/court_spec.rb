require "spec_helper"

describe Court do
  before(:each) do
    @court1 = FactoryGirl.create(:court, :name => "London Court")
    @court2 = FactoryGirl.create(:court, :name => "Something else")
    @ct_county = FactoryGirl.create(:court_type, :name => "County Court")
    @ct_crown = FactoryGirl.create(:court_type, :name => "Crown Court")
    @ct_magistrate = FactoryGirl.create(:court_type, :name => "Magistrates' Court")
    @ct_tribunal = FactoryGirl.create(:court_type, :name => "Tribunal") 

    @at_visiting = FactoryGirl.create(:address_type, :name => "Visiting")
    @at_postal = FactoryGirl.create(:address_type, :name => "Postal")

    @town = FactoryGirl.create(:town, :name => "London")

    @county_court = FactoryGirl.create(:court, :name => 'Some County Court', :court_type_ids => [@ct_county.id]) do |court|
      @visiting_address = court.addresses.create(:address_line_1 => "Some street", :address_type_id => @at_visiting.id, :town_id => @town.id)
      @postal_address = court.addresses.create(:address_line_1 => "Some other street", :address_type_id => @at_postal.id, :town_id => @town.id)
    end

    @crown_court = FactoryGirl.create(:court, :name => 'Some Crown Court', :court_type_ids => [@ct_crown.id])
    @magistrates_court = FactoryGirl.create(:court, :name => 'Some Magistrates Court', :court_type_ids => [@ct_magistrate.id])
    @tribunal = FactoryGirl.create(:court, :name => 'Some Tribunal', :court_type_ids => [@ct_tribunal.id])
  end

  describe "searching" do
    it "should return results if query found in court name" do
      Court.search('London').should == [@court1]
    end
  end

  it "should return no leaflets for County courts" do
    @county_court.leaflets.should be_empty
  end

  it "should include defence and prosecution leaflets for Magistrates courts" do
    @magistrates_court.leaflets.should =~ ["defence", "prosecution"]
  end

  it "should include defence, prosecution and juror leaflets for Crown courts" do
    @crown_court.leaflets.should =~ ["defence", "juror", "prosecution"]
  end

  it "should return no leaflets for Tribunals" do
    @tribunal.leaflets.should be_empty
  end

  it "should return a visiting address" do
    @county_court.addresses.visiting.first.should == @visiting_address
  end

  it "should return a postal address" do
    @county_court.addresses.postal.first.should == @postal_address
  end
end
