require "spec_helper"

describe Court do
  before(:each) do
    @court1 = FactoryGirl.create(:court, :name => "London Court")
    @helpdesk = FactoryGirl.create(:contact_type)
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

    it "should not allow a phone number longer than 13 digits (excluding spaces) to be added to a court" do
      @court1.contacts.create(telephone: "020 8271 1530 or 020 8271 1533")
      @court1.contacts.count.should == 0
    end

    it "should not allow the same phone number to be added to a court contact" do
      2. times { @court1.contacts.create(telephone: "50800 800 8080", contact_type_id: @helpdesk.id) }
      @court1.contacts.count.should == 1
    end
  end
end