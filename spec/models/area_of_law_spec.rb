require 'spec_helper'

describe AreaOfLaw do
  it { should respond_to(:name) }
  it { should respond_to(:slug) }
  it { should validate_presence_of(:name) }
  it { should belong_to(:group).class_name('AreaOfLawGroup') }


  let(:area) { create(:area_of_law, name: 'law1') }

  describe '#path' do
    it 'returns the slugged path' do
      area.path.should eq('/areas-of-law/law1')
    end
  end

  describe '#as_json' do
    it 'returns name and path' do
      area.as_json.should include('name')
      area.as_json.should include('path')
    end
  end
end