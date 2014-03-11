require "spec_helper"

describe Court do
  before(:each) do
    @court1 = create(:court, :name => "London Court")
    @court2 = create(:court, :name => "Something else")
    @ct_county = create(:court_type, :name => "County Court")
    @ct_crown = create(:court_type, :name => "Crown Court")
    @ct_magistrate = create(:court_type, :name => "Magistrates' Court")
    @ct_tribunal = create(:court_type, :name => "Tribunal")

    @at_visiting = create(:address_type, :name => "Visiting")
    @at_postal = create(:address_type, :name => "Postal")

    @town = create(:town, :name => "London")

    @county_court = create(:court, :name => 'Some County Court', :court_type_ids => [@ct_county.id],
                                        :latitude => 51.379743, :longitude => -0.104515) do |court|
      @visiting_address = court.addresses.create(:address_line_1 => "Some street", :address_type_id => @at_visiting.id, :town_id => @town.id)
      @postal_address = court.addresses.create(:address_line_1 => "Some other street", :address_type_id => @at_postal.id, :town_id => @town.id)
    end

    @crown_court = create(:court, :name => 'Some Crown Court', :court_type_ids => [@ct_crown.id]) do |court|
      court.addresses.create(:address_line_1 => "Some other street", :address_type_id => @at_postal.id, :town_id => @town.id)
    end

    @magistrates_court = create(:court, :name => 'Some Magistrates Court', :court_type_ids => [@ct_magistrate.id])
    @tribunal = create(:court, :name => 'Some Tribunal', :court_type_ids => [@ct_tribunal.id])
  end

  describe 'associations' do
    it { should have_many(:councils).through(:court_council_links) }
  end

  describe "searching" do
    it "should return results if query found in court name" do
      Court.search('London').should == [@court1]
    end
  end

  it "should return no leaflets for County courts" do
    @county_court.leaflets.should be_empty
  end

  it "should include defence and prosecution leaflets for Magistrates courts" do
    @magistrates_court.leaflets.should =~ ["defence", "prosecution"]
  end

  it "should include defence, prosecution and juror leaflets for Crown courts" do
    @crown_court.leaflets.should =~ ["defence", "juror", "prosecution"]
  end

  it "should return no leaflets for Tribunals" do
    @tribunal.leaflets.should be_empty
  end

  it "should return a visiting address" do
    @county_court.addresses.visiting.first.should == @visiting_address
  end

  it "should return a postal address" do
    @county_court.addresses.postal.first.should == @postal_address
  end

  it "should not be locatable if it doesn't have a visiting address" do
    @crown_court.locatable?.should be_false
  end

  it "should be locatable if it has a latitude, longitude and visiting address" do
    @county_court.locatable?.should_not be_nil
  end

  context "should have a valid latitude and longitude" do
    it "should fail validation for latitude values outside (-90, 90) and non-numeric values" do
      [-91, 91, "string"].each do |l|
        @county_court.latitude = l
        @county_court.should_not be_valid
      end
    end

    it "should pass validation for latitude values within (-90, 90)" do
      [0, 89.99, -45.4].each do |l|
        @county_court.latitude = l
        @county_court.should be_valid
      end
    end

    it "should fail validation for longitude values outside (-180, 180) and non-numeric values" do
      [181, -181, "string"].each do |l|
        @county_court.longitude = l
        @county_court.should_not be_valid
      end
    end

    it "should pass validation for longitude values within (-180, 180)" do
      [179, -81, 0.45].each do |l|
        @county_court.longitude = l
        @county_court.should be_valid
      end
    end

    it "should validate courts without longitude and latitude that don't have a visiting address" do
      @crown_court.should be_valid
    end
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
    before(:each) do
      @court7 = create(:court, :court_number => 434, :name => 'Children Court A', :display => true, :areas_of_law => [], :latitude => 51.449126, :longitude => -0.110768)
      @council = Council.create(:name => 'Lambeth Borough Council')
      @area_of_law = AreaOfLaw.create(name: "Children")
      @court7.court_council_links.create(council_id: @council.id, area_of_law_id: @area_of_law.id)
    end

    context 'should return the name/names of the court for a given council' do

      context 'when there is only one court' do
        it 'should return Children Court' do
          expect(Court.for_council('Lambeth Borough Council', @area_of_law)).to eq [@court7]
        end
      end

      context 'when there are multiple courts' do
        it 'should return multiple courts sorted by name' do

          @court9 = create(:court, :court_number => 435, :name => 'Children Court B', :display => true, :areas_of_law => [], :latitude => 51.451373, :longitude => -0.106004)
          @court9.court_council_links.create(council_id: @council.id, area_of_law_id: @area_of_law.id)

          expect(Court.for_council('Lambeth Borough Council', @area_of_law)).to eq [@court7, @court9]
        end
      end
    end
  end

  context 'with areas_of_law' do
    let!(:children) { create(:area_of_law, name: 'Children') } 
    let!(:divorce)  { create(:area_of_law, name: 'Divorce') } 
    let!(:adoption) { create(:area_of_law, name: 'Adoption') }
    let!(:court) { create(:court) }
    let!(:council) { create(:council) }

    describe '#children_councils_list' do
      it 'returns a comma seperated list of council names' do
        court.court_council_links.create(council: council, area_of_law: children)
        court.children_councils_list.should eq(council.name)
      end
    end

    describe '#divorce_councils_list' do
      it 'returns a comma seperated list of council names' do
        court.court_council_links.create(council: council, area_of_law: divorce)
        court.divorce_councils_list.should eq(council.name)
      end
    end

    describe '#children_councils_list=' do
      let(:councils) { 2.times.map{ create(:council) } }

      it 'assigns new councils from comma seperated list' do
        court.children_councils_list = councils.map(&:name).join(',')
        court.children_councils.should include(councils.first)
        court.children_councils.should include(councils.last)
      end

      it 'removes councils not in list' do
        councils.each do |council|
          court.court_council_links.create(area_of_law: children, council_id: council.id)
        end

        court.children_councils_list = councils.first.name
        court.children_councils.count.should eq(1)
        court.children_councils.first.name.should eq(councils.first.name)
      end

      it 'does not add a council unless the name is matched' do
        court.children_councils_list = [councils.map(&:name), 'Noname'].flatten.join(',')
        court.children_councils_list.count.should eq(2)
        court.children_councils.should eq(councils)
      end
    end

  end

end
