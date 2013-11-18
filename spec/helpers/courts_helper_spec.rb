require 'spec_helper'

describe CourtsHelper do
  describe "Court numbers display helper" do
    before do 
      @court1 = FactoryGirl.create(:court, :name => "London Court")
      @court2 = FactoryGirl.create(:court, :name => "London Court", :court_number => 2434)
      @court3 = FactoryGirl.create(:court, :name => "London Court", :cci_code => 980)
      @court4 = FactoryGirl.create(:court, :name => "London Court", :court_number => 2434, :cci_code => 980)
      @court5 = FactoryGirl.create(:court, :name => "London Court", :court_number => 899, :cci_code => 899)
    end

    it "displays an empty string when a court has neither court_number nor cci_code" do
      helper.display_court_numbers(@court1).should == ''
    end

    it "displays just the court_number when court has only court_number and no cci_code" do
      helper.display_court_numbers(@court2).should == '#2434'
    end

    it "displays just the cci_code when court has only cci_code and no court_number" do
      helper.display_court_numbers(@court3).should == 'CCI 980'
    end

    it "displays both the court_number and cci_code when court has both" do
      helper.display_court_numbers(@court4).should == '#2434, CCI 980'
    end

    it "displays just the court_number when cci_code exists but is the same as the court_number" do
      helper.display_court_numbers(@court5).should == '#899'
    end
  end
end
