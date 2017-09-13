# == Schema Information
#
# Table name: areas_of_law
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  old_id            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  old_ids_split     :string(255)
#  action            :string(255)
#  sort              :integer
#  slug              :string(255)
#  type_possession   :boolean          default(FALSE)
#  type_bankruptcy   :boolean          default(FALSE)
#  type_money_claims :boolean          default(FALSE)
#  type_children     :boolean          default(FALSE)
#  type_divorce      :boolean          default(FALSE)
#  type_adoption     :boolean          default(FALSE)
#  group_id          :integer
#

require 'spec_helper'

describe AreaOfLaw do
  it { should respond_to(:name) }
  it { should respond_to(:slug) }
  it { should validate_presence_of(:name) }
  it { should belong_to(:group).class_name('AreaOfLawGroup') }

  let(:area) { create(:area_of_law, name: 'law1') }

  describe '#to_param' do

    it 'returns a slug based on name' do
      area = create(:area_of_law, name: 'Area of law slugged')
      expect(area.to_param).to eq('area-of-law-slugged')
    end

    it 'keeps slug history' do
      area = create(:area_of_law, name: 'Area of law slugged')
      area.name = 'Law Slugged'
      area.save!

      expect(area.to_param).to eq('area-of-law-slugged')
      expect(AreaOfLaw.find('area-of-law-slugged')).to eq(area)
    end

  end

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

  describe 'class methods for named records' do
    it 'finds the record with the right name' do
      names = ['Adoption', 'Bankruptcy', 'Children', 'Divorce', 'Housing possession', 'Money claims', 'Civil partnership']
      adoption, bankruptcy, children, divorce, housing_possession, money_claims, civil_partnership =
        names.map { |name| create :area_of_law, name: name }

      expect(AreaOfLaw.adoption).to eq adoption
      expect(AreaOfLaw.bankruptcy).to eq bankruptcy
      expect(AreaOfLaw.children).to eq children
      expect(AreaOfLaw.divorce).to eq divorce
      expect(AreaOfLaw.housing_possession).to eq housing_possession
      expect(AreaOfLaw.money_claims).to eq money_claims
      expect(AreaOfLaw.civil_partnership).to eq civil_partnership
    end
  end
end
