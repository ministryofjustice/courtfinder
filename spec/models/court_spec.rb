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
end