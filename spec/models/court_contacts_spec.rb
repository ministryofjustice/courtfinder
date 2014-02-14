require "spec_helper"

describe Court do
  before(:each) do
    @court1 = FactoryGirl.create(:court, :name => "London Court")
  end

  describe "contacts" do
    it "should allow valid phone contact to be added to a court" do
      @court1.contacts.create(telephone: "0800 800 8080")
      @court1.contacts.count.should == 1
    end

    it "should not allow invalid phone contact to be added to a court" do
      @court1.contacts.create(telephone: "not a number")
      @court1.contacts.count.should == 0
    end
  end
end