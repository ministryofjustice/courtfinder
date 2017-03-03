require 'spec_helper'

describe Facility do
  it { should validate_presence_of(:image_file) }

  describe 'dimension validation' do
    let(:facility) { build(:facility, name: 'baby', image_file: image_file) }
    context 'valid' do
      let(:image_file) { File.open("#{ Rails.root }/spec/fixtures/assets/firstaid.png") }

      it { expect(facility).to be_valid }
    end

    context 'invalid' do
      let(:image_file) { File.open("#{ Rails.root }/spec/fixtures/assets/test.png") }

      it { expect(facility).not_to be_valid }
    end
  end
end
