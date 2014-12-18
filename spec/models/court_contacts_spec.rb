require "spec_helper"

describe Court do
  before(:each) do
    @court1 = FactoryGirl.create(:court, :name => "London Court")
    @helpdesk = FactoryGirl.create(:contact_type)
  end

  describe "contacts" do
    it "should allow valid phone contact to be added to a court" do
      @court1.contacts.create(telephone: "0800 800 8080", contact_type_id: @helpdesk.id)
      @court1.contacts.count.should == 1
    end

    it "should not allow invalid phone contact to be added to a court" do
      @court1.contacts.create(telephone: "not a number", contact_type_id: @helpdesk.id)
      @court1.contacts.count.should == 0
    end

    it "should not allow a phone number longer than 13 digits (excluding spaces) to be added to a court" do
      @court1.contacts.create(telephone: "020 8271 1530 or 020 8271 1533", contact_type_id: @helpdesk.id)
      @court1.contacts.count.should == 0
    end

    it "should not allow a phone number with any characters other than digits and spaces" do
      @court1.contacts.create(telephone: "020 8271 1530 ext", contact_type_id: @helpdesk.id)
      @court1.contacts.count.should == 0
    end

    it "should not allow the same phone number to be added to a court contact" do
      2. times { @court1.contacts.create(telephone: "50800 800 8080", contact_type_id: @helpdesk.id) }
      @court1.contacts.count.should == 1
    end

    describe 'gov uk push' do
      it 'should register a gov uk update job on update' do
        @court1.contacts.create(telephone: "50800 800 8080", contact_type_id: @helpdesk.id) 
        GovUkPushWorker.should_receive(:perform_async).with(action: :update, court_id: @court1.id)
        @court1.contacts.first.update_attribute(:telephone, '40800 800 8080')
      end

      it 'should register a gov uk update job on create' do
        GovUkPushWorker.should_receive(:perform_async).with(action: :update, court_id: @court1.id)
        @court1.contacts.create(telephone: "50800 800 8080", contact_type_id: @helpdesk.id) 
      end

      it 'should register a gov uk update job on destroy' do
        @court1.contacts.create(telephone: "50800 800 8080", contact_type_id: @helpdesk.id) 
        GovUkPushWorker.should_receive(:perform_async).with(action: :update, court_id: @court1.id)
        @court1.contacts.first.destroy
      end
    end
  end
end
