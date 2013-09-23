require 'spec_helper'

describe Location::Location do
  let(:locator) { Location::Location.new }

  describe "#find" do
    it "should return an array" do
      expect(locator.find("SW1H 9AJ")).to eq [51.499612394276, -0.13572284450362]
    end

    context "when not found" do
      it "should return an array of nil" do
        expect(locator.find("SXXX XXX")).to eq [nil, nil]
      end
    end
  end
end
