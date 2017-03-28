require 'spec_helper'

describe CourtsHelper do
  describe "Court numbers display helper" do
    let(:court1) { create(:court, name: 'London Court' ) }
    let(:court2) { create(:court, name: 'London Court', court_number: 2434) }
    let(:court3) { create(:court, name: 'London Court', cci_code: 980) }
    let(:court4) { create(:court, name: 'London Court', court_number: 2434, cci_code: 980) }
    let(:court5) { create(:court, name: 'London Court', court_number: 899, cci_code: 899) }

    context "when a court has neither court_number nor cci_code" do
      it "displays an empty string for short form" do
        helper.display_court_numbers(court1).should == ''
      end

      it "displays an empty string for long form" do
        helper.display_court_numbers(court1, true).should == ''
      end
    end

    context "when court has only court_number and no cci_code" do
      it "displays just the court_number for short form" do
        helper.display_court_numbers(court2).should == '(#2434)'
      end

      it "displays just the court_number for long form" do
        helper.display_court_numbers(court2, true).should == 'Court/tribunal no. 2434'
      end
    end

    context "when court has only cci_code and no court_number" do
      it "displays just the cci_code for short form" do
        helper.display_court_numbers(court3).should == '(CCI 980)'
      end

      it "displays just the cci_code for long form" do
        helper.display_court_numbers(court3, true).should == 'County Court Index 980'
      end
    end

    context "when court has court_number and cci_code" do
      it "it displays both the court_number and cci_code for short form" do
        helper.display_court_numbers(court4).should == '(#2434, CCI 980)'
      end
      it "displays both the court_number and cci_code for long form" do
        helper.display_court_numbers(court4, true).should == 'Court/tribunal no. 2434, County Court Index 980'
      end
    end

    context "when cci_code exists but is the same as the court_number" do
      it "displays just the court_number for short form" do
        helper.display_court_numbers(court5).should == '(#899)'
      end
      it "displays just the court_number for long form" do
        helper.display_court_numbers(court5, true).should == 'Court/tribunal no. 899'
      end
    end
  end

  describe "towns_with_county_where_duplicates_exist" do
    let(:town1){ Town.new(name:'town 1') }
    let(:town2){ Town.new(name:'town 2') }
    let(:towns){ [town1, town2] }
    before{ Town.stub(with_county_name: Town, with_duplicate_count: Town, select: towns) }

    it "gets the Towns with county name" do
      Town.should_receive(:with_county_name).and_return(Town)
      helper.towns_with_county_where_duplicates_exist
    end

    it "gets the Towns with duplicate count" do
      Town.should_receive(:with_duplicate_count).and_return(Town)
      helper.towns_with_county_where_duplicates_exist
    end

    it "manually selects the towns.id and towns.name" do
      Town.should_receive(:select).with('towns.id, towns.name').and_return(towns)
      helper.towns_with_county_where_duplicates_exist
    end

    describe "each returned town" do

      it "is mapped to a new TownDisambiguator" do
        TownDisambiguator.should_receive( :new ).exactly(:once).ordered.with(town1).and_return('disambiguated town 1')
        TownDisambiguator.should_receive( :new ).exactly(:once).ordered.with(town2).and_return('disambiguated town 2')
        expect( helper.towns_with_county_where_duplicates_exist ).to eq( ['disambiguated town 1', 'disambiguated town 2'] )
      end
    end
  end

  describe 'family_areas_of_law' do
    it "call selected areas of law" do
      expect(AreaOfLaw).to receive(:where).
        with(name: ['Children','Divorce','Adoption', 'Civil partnership']).
        and_return []
      family_areas_of_law { |area, id| }
    end
  end
end
