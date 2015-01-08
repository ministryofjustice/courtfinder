require 'spec_helper'

describe Admin::CourtsHelper do
  
  describe '#external_court_path' do
    let(:court){ double('court', slug: 'my-court-slug') }
    
    it "returns /courts/(court slug)" do
      expect(helper.external_court_path(court)).to eq('/courts/my-court-slug')
    end
  end
end