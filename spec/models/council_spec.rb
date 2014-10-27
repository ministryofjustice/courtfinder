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
    include CourtCouncilHelper

    let(:children) { create :area_of_law }
    let(:divorce)  { create :area_of_law }

    let(:children_court) { create :court }
    let(:divorce_court)  { create :court }

    before(:each) do
      @council_with_both     = create :council
      @council_with_children = create :council
      @council_with_divorce  = create :council
      @council_with_neither  = create :council

      add_councils_to_court councils: [@council_with_both, @council_with_children], court: children_court, area_of_law: children
      add_councils_to_court councils: [@council_with_both, @council_with_divorce], court: divorce_court, area_of_law: divorce
    end

    it 'returns a councils without assignments for area of law' do
      unassigned_for_children = Council.unassigned_for_area_of_law(children)

      expect(unassigned_for_children.size).to eq 2
      expect(unassigned_for_children).to include @council_with_divorce, @council_with_neither
    end

    it 'returns empty array when all all councils have assigned a court for an area of law' do
      add_councils_to_court councils: [@council_with_divorce, @council_with_neither], court: children_court, area_of_law: children

      expect(Council.unassigned_for_area_of_law(children)).to be_empty
      expect(Council.unassigned_for_area_of_law(divorce)).to include @council_with_children, @council_with_neither
    end

    context 'a court with councils assigned for multiple areas_of_law' do
      it 'returns empty array when all all councils have assigned a court for an area of law' do
        add_councils_to_court councils: [@council_with_divorce, @council_with_neither], court: children_court, area_of_law: children
        add_councils_to_court councils: [@council_with_children, @council_with_neither], court: divorce_court, area_of_law: divorce

        expect(Council.unassigned_for_area_of_law(children)).to be_empty
        expect(Council.unassigned_for_area_of_law(divorce)).to be_empty
      end
    end
  end
end
