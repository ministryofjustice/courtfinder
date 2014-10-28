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
    it { should have_many(:councils).through(:jurisdictions) }
  end

  describe "searching" do
    it "should return results if query found in court name" do
      Court.search('London').should == [@court1]
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
    @crown_court.locatable?.should be_false
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

  describe 'Find court by council name' do
    include CourtCouncilHelper

    before(:each) do
      @court7 = create(:court, :court_number => 434, :name => 'Children Court A', :display => true, :areas_of_law => [], :latitude => 51.449126, :longitude => -0.110768)
      @council = Council.create(:name => 'Lambeth Borough Council')
      @area_of_law = create(:area_of_law, name: "Children", type_children: true)
      add_councils_to_court councils: [@council], court: @court7, area_of_law: @area_of_law
    end

    context 'should return the name/names of the court for a given council' do

      describe '#for_council_and_area_of_law' do
        context 'when there is only one court' do
          it 'should return Children Court' do
            expect(Court.for_council_and_area_of_law('Lambeth Borough Council', @area_of_law)).to eq [@court7]
          end
        end

        context 'when there are multiple courts' do
          it 'should return multiple courts sorted by name' do

            @court9 = create(:court, :court_number => 435, :name => 'Children Court B', :display => true, :areas_of_law => [], :latitude => 51.451373, :longitude => -0.106004)
            add_councils_to_court councils: [@council], court: @court9, area_of_law: @area_of_law

            expect(Court.for_council_and_area_of_law('Lambeth Borough Council', @area_of_law)).to eq [@court7, @court9]
          end
        end
      end
    end
  end

  context 'with areas_of_law' do
    include CourtCouncilHelper

    let!(:children) { create(:area_of_law, name: 'Children') }
    let!(:divorce)  { create(:area_of_law, name: 'Divorce') }
    let!(:adoption) { create(:area_of_law, name: 'Adoption') }
    let!(:possession) { create(:area_of_law, name: 'Housing possession') }
    let!(:bankruptcy) { create(:area_of_law, name: 'Bankruptcy') }
    let!(:money) { create(:area_of_law, name: 'Money claims') }
    let!(:court) { create(:court) }
    let!(:council) { create(:council) }

    describe '#children_councils_list' do
      it 'returns a comma seperated list of council names' do
        add_councils_to_court councils: [council], court: court, area_of_law: children
        add_councils_to_court councils: [create(:council)], court: court, area_of_law: divorce
        court.children_councils_list.should eq(council.name)
      end
    end

    describe '#divorce_councils_list' do
      it 'returns a comma seperated list of council names' do
        add_councils_to_court councils: [create(:council)], court: court, area_of_law: children
        add_councils_to_court councils: [council], court: court, area_of_law: divorce
        court.divorce_councils_list.should eq(council.name)
      end
    end

    describe '#possession_councils_list' do
      it 'returns a comma seperated list of council names' do
        add_councils_to_court councils: [council], court: court, area_of_law: possession
        court.housing_possession_councils_list.should eq(council.name)
      end
    end

    describe '#money_councils_list' do
      it 'returns a comma seperated list of council names' do
        add_councils_to_court councils: [council], court: court, area_of_law: money
        court.money_claims_councils_list.should eq(council.name)
      end
    end

    describe '#children_councils_list=' do
      let(:councils) { ['A', 'B'].map{ |name| create(:council, name: "Council #{name}") } }

      it 'assigns new councils from comma seperated list' do
        court.children_councils_list = councils.map(&:name).join(',')
        court.children_councils.should include(councils.first)
        court.children_councils.should include(councils.last)
      end

      it 'removes councils not in list' do
        councils.each do |council|
          add_councils_to_court councils: [council], court: court, area_of_law: children
        end

        court.children_councils_list = councils.first.name
        court.children_councils.count.should eq(1)
        court.children_councils.first.name.should eq(councils.first.name)
      end

      it 'does not add a council unless the name is matched' do
        court.children_councils_list = [councils.map(&:name), 'Noname'].flatten.join(',')
        court.children_councils.count.should eq(2)
        court.children_councils.should eq(councils)
      end

      it 'reports invalid council names' do
        court.children_councils_list = ['Bad council 1', councils.map(&:name), 'Bad council 2'].flatten.join(',')
        expect(court.invalid_councils.size).to eq 2
        expect(court.invalid_councils).to include('Bad council 1', 'Bad council 2')
      end

      it 'reports no invalid council names if there aren\'t any' do
        court.children_councils_list = [councils.map(&:name)].flatten.join(',')
        expect(court.invalid_councils).to be_empty
      end
    end

    describe '#bankruptcy_councils_list=' do
      let(:councils) { ['A', 'B'].map{ |name| create(:council, name: "Council #{name}") } }

      it 'assigns new councils from comma seperated list' do
        court.bankruptcy_councils_list = councils.map(&:name).join(',')
        court.bankruptcy_councils.should include(councils.first)
        court.bankruptcy_councils.should include(councils.last)
      end

      it 'removes councils not in list' do
        councils.each do |council|
          add_councils_to_court councils: [council], court: court, area_of_law: bankruptcy
        end

        court.bankruptcy_councils_list = councils.first.name
        court.bankruptcy_councils.count.should eq(1)
        court.bankruptcy_councils.first.name.should eq(councils.first.name)
      end

      it 'does not add a council unless the name is matched' do
        court.bankruptcy_councils_list = [councils.map(&:name), 'Noname'].flatten.join(',')
        court.bankruptcy_councils.count.should eq(2)
        court.bankruptcy_councils.should eq(councils)
      end

      it 'reports invalid council names' do
        court.bankruptcy_councils_list = ['Bad council 1', councils.map(&:name), 'Bad council 2'].flatten.join(',')
        expect(court.invalid_councils.size).to eq 2
        expect(court.invalid_councils).to include('Bad council 1', 'Bad council 2')
      end

      it 'reports no invalid council names if there aren\'t any' do
        court.bankruptcy_councils_list = [councils.map(&:name)].flatten.join(',')
        expect(court.invalid_councils).to be_empty
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
          expect(court.children_single_point_of_entry).to be_true
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
          expect(court.children_single_point_of_entry).to be_false
        end
      end

      context 'when the court has no remit for Children' do
        it 'returns false' do
          expect(court.children_single_point_of_entry).to be_false
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
          expect(court.remits.find_by_area_of_law_id!(children.id).single_point_of_entry).to be_true
        end
      end

      context 'when the court has no remit for Children' do
        it 'creates a remit with the appropriate value' do
          court.children_single_point_of_entry = true
          expect(court.remits.find_by_area_of_law_id!(children.id).single_point_of_entry).to be_true
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

  describe '#visiting_postcode_changed?' do
    context 'for an existing court with a visiting address' do
      let(:court) { @county_court }

      context 'which has changed' do
        before(:each) do
          court.visiting_addresses.first.postcode = 'SW1A 1AA'
        end

        it 'returns true' do
          expect(court.visiting_postcode_changed?).to be_true
        end
      end

      context 'which hasn\'t changed' do
        it 'returns false' do
          expect(court.visiting_postcode_changed?).to be_false
        end
      end
    end

    context 'for a new court' do
      let(:court) { Court.new }

      context 'with a visiting address with a postcode' do
        before(:each) do
          court.addresses = [@visiting_address1]
        end

        it 'returns true' do
          expect(court.visiting_postcode_changed?).to be_true
        end
      end

      context 'without a visiting address' do
        it 'returns false' do
          expect(court.visiting_postcode_changed?).to be_false
        end
      end
    end
  end
end
