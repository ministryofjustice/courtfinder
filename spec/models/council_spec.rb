# == Schema Information
#
# Table name: councils
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "spec_helper"

describe Council do
  it { should respond_to :name }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }

  describe 'associations' do
    it { is_expected.to have_many(:courts).through(:court_council_links) }
    it { is_expected.to have_many :jurisdictions }
  end

  describe '#unassigned_for_area_of_law' do
  	let(:children) { create(:area_of_law, name: 'Children') }
  	let(:divorce) { create(:area_of_law, name: 'Divorce') }
  	let(:council) { create(:council) }
  	let(:court) { create(:court) }

  	it 'returns a councils without assignments for area of law' do
  		Council.unassigned_for_area_of_law(children).should eq([council])
  	end

  	it 'returns empty array when all all councils have assigned a court for an area of law' do
  		council.court_council_links.create!(court: court, area_of_law: children)
  		
  		Council.unassigned_for_area_of_law(children).should eq([])
  		Council.unassigned_for_area_of_law(divorce).should eq([council])
  	end

    context 'a court with councils assigned for multiple areas_of_law' do
      
      it 'returns empty array when all all councils have assigned a court for an area of law' do
        council.court_council_links.create!(court: court, area_of_law: children)
        council.court_council_links.create!(court: court, area_of_law: divorce)
        
        Council.unassigned_for_area_of_law(children).should eq([])
      end

    end

  end
end
