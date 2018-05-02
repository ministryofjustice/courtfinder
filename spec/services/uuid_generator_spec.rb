require "spec_helper"

describe UuidGenerator do
  describe 'with basic setup' do
    it "does something" do
      uuid = UuidGenerator.new.generate
      expect(uuid).not_to eql('')
    end
  end
end
