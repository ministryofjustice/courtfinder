require 'spec_helper'

describe OfficialPostcode, type: :model do

  describe "is_valid_postcode?" do
    let(:postcode) { create(:official_postcode).postcode }

    it "is not valid" do
      result = OfficialPostcode.is_valid_postcode?('N10 2LE')
      expect(result).to be_falsey
    end

    it "is valid" do
      result = OfficialPostcode.is_valid_postcode?(postcode)
      expect(result).to be_truthy
    end
  end
end
