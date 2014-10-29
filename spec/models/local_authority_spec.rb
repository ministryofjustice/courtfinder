# == Schema Information
#
# Table name: local_authorities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "spec_helper"

describe LocalAuthority do
  it { should respond_to :name }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }

  describe 'associations' do
    it { is_expected.to have_many :jurisdictions }
    it { is_expected.to have_many(:remits).through(:jurisdictions) }
    it { is_expected.to have_many(:courts).through(:remits) }
  end

  describe '#unassigned_for_area_of_law' do
    include CourtLocalAuthorityHelper

    let(:children) { create :area_of_law }
    let(:divorce)  { create :area_of_law }

    let(:children_court) { create :court }
    let(:divorce_court)  { create :court }

    before(:each) do
      @local_authority_with_both     = create :local_authority
      @local_authority_with_children = create :local_authority
      @local_authority_with_divorce  = create :local_authority
      @local_authority_with_neither  = create :local_authority

      add_local_authorities_to_court local_authorities: [@local_authority_with_both, @local_authority_with_children], court: children_court, area_of_law: children
      add_local_authorities_to_court local_authorities: [@local_authority_with_both, @local_authority_with_divorce], court: divorce_court, area_of_law: divorce
    end

    it 'returns a local authority without assignments for area of law' do
      unassigned_for_children = LocalAuthority.unassigned_for_area_of_law(children)

      expect(unassigned_for_children.size).to eq 2
      expect(unassigned_for_children).to include @local_authority_with_divorce, @local_authority_with_neither
    end

    it 'returns empty array when all all local authorities have assigned a court for an area of law' do
      add_local_authorities_to_court local_authorities: [@local_authority_with_divorce, @local_authority_with_neither], court: children_court, area_of_law: children

      expect(LocalAuthority.unassigned_for_area_of_law(children)).to be_empty
      expect(LocalAuthority.unassigned_for_area_of_law(divorce)).to include @local_authority_with_children, @local_authority_with_neither
    end

    context 'a court with local authorities assigned for multiple areas_of_law' do
      it 'returns empty array when all all local authorities have assigned a court for an area of law' do
        add_local_authorities_to_court local_authorities: [@local_authority_with_divorce, @local_authority_with_neither], court: children_court, area_of_law: children
        add_local_authorities_to_court local_authorities: [@local_authority_with_children, @local_authority_with_neither], court: divorce_court, area_of_law: divorce

        expect(LocalAuthority.unassigned_for_area_of_law(children)).to be_empty
        expect(LocalAuthority.unassigned_for_area_of_law(divorce)).to be_empty
      end
    end
  end
end
