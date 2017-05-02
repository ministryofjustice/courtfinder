# == Schema Information
#
# Table name: courts
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  court_number          :integer
#  info                  :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  area_id               :integer
#  cci_code              :integer
#  old_id                :integer
#  old_court_type_id     :integer
#  slug                  :string(255)
#  old_postal_address_id :integer
#  old_court_address_id  :integer
#  latitude              :decimal(, )
#  longitude             :decimal(, )
#  old_image_id          :integer
#  image                 :string(255)
#  image_description     :string(255)
#  image_file            :string(255)
#  display               :boolean
#  gmaps                 :boolean
#  alert                 :string(255)
#  info_leaflet          :text
#  defence_leaflet       :text
#  prosecution_leaflet   :text
#  juror_leaflet         :text
#  cci_identifier        :integer
#  directions            :text
#  parking_onsite        :string(255)
#  parking_offsite       :string(255)
#  hide_aols             :boolean default false
#

require "spec_helper"

describe Court do
  before(:each) do
    @court1 = create(:court, :name => "London Court")
    @court2 = create(:court, :name => "Something else")
    @ct_county = create(:court_type, :name => "County Court")
    @ct_crown = create(:court_type, :name => "Crown Court")
    @ct_magistrate = create(:court_type, :name => "Magistrates Court")
    @ct_tribunal = create(:court_type, :name => "Tribunal")
    @ct_family = create(:court_type, :name => "Family Court")

    @at_visiting = create(:address_type, :name => "Visiting")
    @at_postal = create(:address_type, :name => "Postal")

    @town = create(:town, :name => "London")

    @visiting_address1 = create(:address, :address_line_1 => "Some street", :postcode => "SW1H9AJ", :address_type_id => @at_visiting.id, :town_id => @town.id)
    @postal_address = create(:address, :address_line_1 => "Some other street", :address_type_id => @at_postal.id, :town_id => @town.id)

    VCR.use_cassette('postcode_found') do
      @county_court = create(:court, :name => 'Some County Court', :court_type_ids => [@ct_county.id],
                                          :address_ids => [@visiting_address1.id, @postal_address.id])
    end

    @crown_court = create(:court, :name => 'Some Crown Court', :court_type_ids => [@ct_crown.id],
                                        :address_ids => [@postal_address.id])

    @magistrates_court = create(:court, :name => 'Some Magistrates Court', :court_type_ids => [@ct_magistrate.id])
    @tribunal = create(:court, :name => 'Some Tribunal', :court_type_ids => [@ct_tribunal.id])
    @family_court = create(:court, :name => 'Some Family Court', :court_type_ids => [@ct_family.id])

    @leaflets_types = ["visitor", "defence", "prosecution", "juror"]
  end

  describe 'associations' do
    it { should have_many :remits }
    it { should have_many(:jurisdictions).through(:remits) }
    it { should have_many(:local_authorities).through(:jurisdictions) }
  end

  describe "searching" do
    it "should return results if query found in court name" do
      Court.search('London').should == [@court1]
    end
  end

  describe '#add_uuid_before_validation' do
    it 'should write new records with a uuid' do
      expect(@court1.uuid).not_to be_nil
    end

    it 'should write different uuids for each record it writes' do
      court1 = create(:court, name: 'Court a')
      court2 = create(:court, name: 'Court b')
      expect(court1.uuid).not_to be_nil
      expect(court1.uuid).not_to eq court2.uuid
    end

    it 'should create uuids for existing records where the uuid is blank' do
      court = build(:court, name: 'My Court')
      court.uuid = nil
      court.save
      expect(court.uuid).not_to be_nil
    end
  end

  it "should return visitors leaflets only for County courts" do
    @county_court.leaflets.should eq @leaflets_types.take(1)
  end

  it "should include  visitors, defence and prosecution leaflets for Magistrates courts" do
    @magistrates_court.leaflets.should eq @leaflets_types.take(3)
  end

  it "should include visitors, defence, prosecution and juror leaflets for Crown courts" do
    @crown_court.leaflets.should eq @leaflets_types
  end

  it "should return visitors leaflets only for Tribunals" do
    @tribunal.leaflets.should eq @leaflets_types.take(1)
  end

  it "should return visitors leaflets only for Family Courts" do
    @family_court.leaflets.should eq @leaflets_types.take(1)
  end

  it "should return a visiting address" do
    @county_court.addresses.visiting.first.should == @visiting_address1
  end

  pending "should return a postal address" do
    @county_court.addresses.postal.first.should == @postal_address
  end

  it "should not be locatable if it doesn't have a visiting address" do
    @crown_court.locatable?.should be_falsey
  end

  it "should be locatable if it has a latitude, longitude and visiting address" do
    @county_court.locatable?.should_not be_nil
  end

  describe "Postcode courts" do
    before(:each) do
      @london_court = create(:court, :name => "London Court")
      @london_court.postcode_courts.create(:postcode => 'SE19NH')
      @london_court.postcode_courts.create(:postcode => 'SE153AN')
    end

    it "should return a comma separated list of postcodes the court has jurisdiction over" do
      @london_court.postcode_list.should == 'SE153AN, SE19NH'
    end

    it "should not allow the same postcode to be assigned to more than one court" do
      pc = @county_court.postcode_courts.new(:postcode => 'SE19NH')
      pc.should_not be_valid
    end
  end

  describe 'Find court by local authority name' do
    include CourtLocalAuthorityHelper

    before(:each) do
      @court7 = create(:court, :court_number => 434, :name => 'Children Court A', :display => true, :areas_of_law => [], :latitude => 51.449126, :longitude => -0.110768)
      @local_authority = LocalAuthority.create(:name => 'Lambeth Borough Council')
      @area_of_law = create(:area_of_law, name: "Children", type_children: true)
      add_local_authorities_to_court local_authorities: [@local_authority], court: @court7, area_of_law: @area_of_law
    end

    context 'should return the name/names of the court for a given local authority' do

      describe '#for_local_authority_and_area_of_law' do
        context 'when there is only one court' do
          it 'should return Children Court' do
            expect(Court.for_local_authority_and_area_of_law('Lambeth Borough Council', @area_of_law)).to eq [@court7]
          end
        end

        context 'when there are multiple courts' do
          it 'should return multiple courts sorted by name' do

            @court9 = create(:court, :court_number => 435, :name => 'Children Court B', :display => true, :areas_of_law => [], :latitude => 51.451373, :longitude => -0.106004)
            add_local_authorities_to_court local_authorities: [@local_authority], court: @court9, area_of_law: @area_of_law

            expect(Court.for_local_authority_and_area_of_law('Lambeth Borough Council', @area_of_law)).to eq [@court7, @court9]
          end
        end
      end
    end
  end

  context 'with areas_of_law' do
    include CourtLocalAuthorityHelper

    let!(:children) { create(:area_of_law, name: 'Children') }
    let!(:divorce)  { create(:area_of_law, name: 'Divorce') }
    let!(:adoption) { create(:area_of_law, name: 'Adoption') }
    let!(:court) { create(:court, hide_aols: false) }
    let!(:local_authority) { create(:local_authority) }

    describe '#courts supports hide_aols' do
      it 'checks model supprts hide_aols' do
        court.hide_aols.should eq(false)
      end
    end

    describe '#children_local_authorities_list' do
      it 'returns a comma seperated list of local authority names' do
        add_local_authorities_to_court local_authorities: [local_authority], court: court, area_of_law: children
        add_local_authorities_to_court local_authorities: [create(:local_authority)], court: court, area_of_law: divorce
        court.children_local_authorities_list.should eq(local_authority.name)
      end
    end

    describe '#divorce_local_authorities_list' do
      it 'returns a comma seperated list of local authority names' do
        add_local_authorities_to_court local_authorities: [create(:local_authority)], court: court, area_of_law: children
        add_local_authorities_to_court local_authorities: [local_authority], court: court, area_of_law: divorce
        court.divorce_local_authorities_list.should eq(local_authority.name)
      end
    end

    describe '#children_local_authorities_list=' do
      let(:local_authorities) { ['A', 'B'].map{ |name| create(:local_authority, name: "Local Authority #{name}") } }

      it 'assigns new local authorities from comma seperated list' do
        court.children_local_authorities_list = local_authorities.map(&:name).join(',')
        court.children_local_authorities.should include(local_authorities.first)
        court.children_local_authorities.should include(local_authorities.last)
      end

      it 'removes local authorities not in list' do
        local_authorities.each do |local_authority|
          add_local_authorities_to_court local_authorities: [local_authority], court: court, area_of_law: children
        end

        court.children_local_authorities_list = local_authorities.first.name
        court.children_local_authorities.count.should eq(1)
        court.children_local_authorities.first.name.should eq(local_authorities.first.name)
      end

      it 'does not add a local authority unless the name is matched' do
        court.children_local_authorities_list = [local_authorities.map(&:name), 'Noname'].flatten.join(',')
        court.children_local_authorities.count.should eq(2)
        court.children_local_authorities.should eq(local_authorities)
      end

      it 'reports invalid local authority names' do
        court.children_local_authorities_list = ['Bad local authority 1', local_authorities.map(&:name), 'Bad local authority 2'].flatten.join(',')
        expect(court.invalid_local_authorities.size).to eq 2
        expect(court.invalid_local_authorities).to include('Bad local authority 1', 'Bad local authority 2')
      end

      it 'reports no invalid local authority names if there aren\'t any' do
        court.children_local_authorities_list = [local_authorities.map(&:name)].flatten.join(',')
        expect(court.invalid_local_authorities).to be_empty
      end
    end

    describe '#children_single_point_of_entry' do
      context 'when the court is a single point of entry for Children' do
        before(:each) do
          court.remits.create! do |remit|
            remit.area_of_law = children
            remit.single_point_of_entry = true
          end
        end

        it 'returns true' do
          expect(court.children_single_point_of_entry).to be_truthy
        end
      end

      context 'when the court is not a single point of entry for Children' do
        before(:each) do
          court.remits.create! do |remit|
            remit.area_of_law = children
            remit.single_point_of_entry = false
          end
        end

        it 'returns false' do
          expect(court.children_single_point_of_entry).to be_falsey
        end
      end

      context 'when the court has no remit for Children' do
        it 'returns false' do
          expect(court.children_single_point_of_entry).to be_falsey
        end
      end
    end

    describe '#children_single_point_of_entry=' do
      context 'when the court already has a remit for Children' do
        before(:each) do
          court.remits.create! do |remit|
            remit.area_of_law = children
            remit.single_point_of_entry = false
          end
        end

        it 'updates the remit' do
          court.children_single_point_of_entry = true
          expect(court.remits.find_by_area_of_law_id!(children.id).single_point_of_entry).to be_truthy
        end
      end

      context 'when the court has no remit for Children' do
        it 'creates a remit with the appropriate value' do
          court.children_single_point_of_entry = true
          expect(court.remits.find_by_area_of_law_id!(children.id).single_point_of_entry).to be_truthy
        end
      end
    end
  end

  describe '#visiting_postcode' do
    context 'when the court has a visiting address' do
      it 'returns the postcode of the visiting address' do
        expect(@county_court.visiting_postcode).to eq 'SW1H9AJ'
      end
    end

    context 'when the court doesn\'t have a visiting address' do
      it 'returns nil' do
        expect(@crown_court.visiting_postcode).to be_nil
      end
    end
  end

  describe 'by_postcode_court_mapping' do
    let(:postcode_court) { create(:postcode_court, court: @court1) }

    it "return court" do
      list = Court.by_postcode_court_mapping(postcode_court.postcode)
      expect(list.first).to eql(@court1)
    end

    it "return empty array" do
      list = Court.by_postcode_court_mapping(postcode_court.postcode, AreaOfLaw.last)
      expect(list).to be_empty
    end

    it "return empty array" do
      list = Court.by_postcode_court_mapping(postcode_court.postcode, @court2.areas_of_law.last)
      expect(list).to be_empty
    end
  end

  describe 'slug format validation' do
    let(:court) { create(:court, name: 'Court a') }

    before { court.slug = test_slug }

    context 'lettters and underscore' do
      let(:test_slug) { 'Courtjustice' }
      it { expect(court).to be_valid }
    end

    context 'not allowed & character' do
      let(:test_slug) { 'court-&-justice' }
      it { expect(court).not_to be_valid }
    end

    context 'not allowed numeric character' do
      let(:test_slug) { 'Court-and-justice1' }
      it { expect(court).not_to be_valid }
    end

    context 'not allowed ? character' do
      let(:test_slug) { 'court-and-justice?' }
      it { expect(court).not_to be_valid }
    end
  end

  describe 'slug uniqueness' do
    let(:court1) { create(:court, name: 'Common court name') }
    let(:court2) { create(:court, name: 'Common court name') }
    let(:court3) { create(:court, name: 'Common court name') }

    before { court1; court2; court3 }

    it { expect(court1.slug).to eql('common-court-name') }
    it { expect(court2.slug).to eql('common-court-name-a') }
    it { expect(court3.slug).to eql('common-court-name-b') }
  end

  describe 'name format validation' do
    let(:court1) { build(:court, name: 'Common court name') }
    let(:court2) { build(:court, name: 'Common 1') }
    let(:court3) { build(:court, name: 'Common &') }
    let(:court4) { build(:court, name: "Postal Magistrates' Court") }

    it { expect(court1).to be_valid }
    it { expect(court2).not_to be_valid }
    it { expect(court3).not_to be_valid }
    it { expect(court4).to be_valid }
  end
end
