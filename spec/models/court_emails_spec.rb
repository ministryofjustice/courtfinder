require "spec_helper"

describe Court do
  before(:each) do
    @court1 = FactoryGirl.create(:court, name: "London Court")
  end

  describe "emails" do
    it "should allow valid email to be added to a court" do
      @court1.emails.create(address: "valid_email@example.com")
      @court1.emails.count.should == 1
    end

    it "should not allow invalid email to be added to a court" do
      @court1.emails.create(address: "invalid_email")
      @court1.emails.count.should == 0
    end

    it "should not allow the same email address to be added to a court more than once" do
      ["valid_email@example.com", "Gwent-MC-PostCourt@hmcts.gsi.gov.uk", "hearings@Aylesbury.countycourt.gsi.gov.uk"]. each do |_email|
        2.times { @court1.emails.create(address: "valid_email@example.com") }
        @court1.emails.count.should == 1
      end
    end
  end
end
