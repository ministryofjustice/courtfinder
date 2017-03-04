# == Schema Information
#
# Table name: courts
#
#  id                   :integer          not null, primary key
#  message              :text
#  show                 :boolean          not null, default false
#

require "spec_helper"

describe EmergencyMessage do
  before(:each) do
    EmergencyMessage.destroy_all()
    @message = create(:emergency_message, :message => "Test message", :show => false)
  end

  describe "fetching" do
    it "should return 1 result" do
      @message2 = create(:emergency_message, :message => "Another Test message", :show => false)
      expect(@message.id).to be == 1
    end
  end

  describe 'validation should be - false' do
    it 'should write new records defaulted to false' do
      expect(@message.show).to be_falsey
    end
  end

  describe 'Message should be' do
    it "equal to 'Test message'" do
      @message.message.should eq("Test message")
    end
  end
end