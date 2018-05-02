require 'spec_helper'

describe Location::LocationGenerator do
  let(:location_generator) do
    locator = double("locator").as_null_object
    Location::LocationGenerator.new(locator)
  end

  describe "#missing_location?" do
    context "when the court does not have a location" do
      it "should be true" do
        court = double("court")
        court.stub(:locatable?).and_return(false)

        expect(location_generator.missing_location?(court)).to be_truthy
      end
    end

    context "when the court has a location" do
      it "should be false" do
        court = double("court")
        court.stub(:locatable?).and_return(true)

        expect(location_generator.missing_location?(court)).to be_falsey
      end
    end
  end

  describe "#generate_location_for" do
    it "should retrieve the postcode from the first address of the court" do
      court = double("court").as_null_object
      address = double("address").as_null_object

      address.should_receive(:postcode).and_return("SE1 2AA")
      court.should_receive(:addresses).and_return([address])

      location_generator.generate_location_for(court)
    end

    it "should ignore a court without an address" do
      court = double("court").as_null_object

      court.should_receive(:addresses).and_return([])
      expect(location_generator.generate_location_for(court)).to be_falsey
    end

    it "should call find on a locator" do
      locator = double('locator')
      court = double('court').as_null_object
      address = double("address").as_null_object
      address.stub(:postcode).and_return("SE1 2AA")
      court.stub(:addresses).and_return([address])

      locator.should_receive(:find).with("SE1 2AA")

      Location::LocationGenerator.new(locator).generate_location_for(court)
    end

    it "should update the longitude and latitude" do
      locator = double('locator')
      court = double('court').as_null_object
      address = double("address").as_null_object
      address.stub(:postcode).and_return("SE1 2AA")
      court.stub(:addresses).and_return([address])

      locator.stub(:find).with("SE1 2AA").and_return([51.504850118053500, -0.078692556073505])

      court.should_receive(:update_attributes).with(latitude: 51.5048501180535, longitude: -0.078692556073505).and_return(true)
      Location::LocationGenerator.new(locator).generate_location_for(court)
    end
  end

  describe "#process" do
    it "should ignore courts with map locations" do
      court = double('court').as_null_object
      court.stub(:locatable?).and_return(true)

      location_generator.should_not_receive(:generate_location_for)

      location_generator.process([court])
    end

    it "should generate map location for a court that can't be located" do
      court = double('court').as_null_object
      court.stub(:locatable?).and_return(false)

      location_generator.should_receive(:generate_location_for)

      location_generator.process([court])
    end
  end

  describe "#load" do
    let(:file_with_one_entry) { "spec/fixtures/manual_map_location.yml" }
    let(:file_with_two_entries) { "spec/fixtures/manual_map_locations.yml" }
    let(:court) { double('court').as_null_object }

    describe 'when there is one court' do
      it "should find a court" do
        Court.should_receive(:find_by).with(name: 'County Court Money Claims Centre').and_return(court)
        location_generator.load(file_with_one_entry)
      end

      it "should update the longitude and latitude" do
        Court.stub(:find_by).with(name: 'County Court Money Claims Centre').and_return(court)
        court.should_receive(:update_attributes).with(latitude: 53.48150, longitude: -2.28044).and_return(:true)
        location_generator.load(file_with_one_entry)
      end
    end

    describe 'when there is more courts' do
      it "should find two courts" do
        Court.should_receive(:find_by).twice.and_return(court)
        location_generator.load(file_with_two_entries)
      end

      it "should update the longitude and latitude" do
        Court.stub(:find_by).and_return(court)
        court.should_receive(:update_attributes).twice.and_return(:true)
        location_generator.load(file_with_two_entries)
      end
    end
  end
end
