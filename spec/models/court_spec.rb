require "spec_helper"

describe Court do
  describe "searching" do
    before(:each) do
      @court1 = FactoryGirl.create(:court, :name => "London Court")
      @court2 = FactoryGirl.create(:court, :name => "Something else")
    end

    it "should return results if query found in court name" do
      Court.search('London').should == [@court1]
    end
  end

  before(:all) do
    @ct_county = FactoryGirl.create(:court_type, :name => "County Court")
    @ct_crown = FactoryGirl.create(:court_type, :name => "Crown Court")
    @ct_magistrate = FactoryGirl.create(:court_type, :name => "Magistrates' Court")
    @ct_tribunal = FactoryGirl.create(:court_type, :name => "Tribunal")    
    @county_court = FactoryGirl.create(:court, :name => 'Some County Court', :court_type_ids => [@ct_county.id])
    @crown_court = FactoryGirl.create(:court, :name => 'Some Crown Court', :court_type_ids => [@ct_crown.id])
    @magistrates_court = FactoryGirl.create(:court, :name => 'Some Magistrates Court', :court_type_ids => [@ct_magistrate.id])
    @tribunal = FactoryGirl.create(:court, :name => 'Some Tribunal', :court_type_ids => [@ct_tribunal.id])
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
end
