shared_examples "a search with area of law" do |area_of_law_name|

  let!(:children) { create(:area_of_law, name: 'Children', type_children: true) }
  let!(:divorce) { create(:area_of_law, name: 'Divorce', type_divorce: true) }
  let!(:adoption) { create(:area_of_law, name: 'Adoption', type_adoption: true) }
  let!(:at_visiting) { create(:address_type, name: "Visiting") }
  let!(:town) { create(:town, name: "London") }
  let!(:visiting_address) do
    create(:address, address_line_1: "Some street",
                     address_type_id: at_visiting.id, postcode: 'SE19NH', town_id: town.id)
  end

  context "Chosen area of law is #{area_of_law_name}" do
    include CourtLocalAuthorityHelper

    let!(:area) { AreaOfLaw.find_by(name: area_of_law_name) }
    # Location: http://mapit.service.dsd.io/nearest/4326/-0.110768,51449126: SW2 2YH (Inside the Lambeth Borough Council)
    let!(:court7) do
      VCR.use_cassette('postcode_found') do
        create(:court, court_number: 434, name: "#{area.name} Court A", display: true, areas_of_law: [area],
                       address_ids: [visiting_address.id])
      end
    end
    let!(:local_authority) { LocalAuthority.create(name: 'Lambeth Borough Council') }

    before(:each) do
      add_local_authorities_to_court local_authorities: [local_authority], court: court7, area_of_law: area
    end

    it "should return only one search result if the postcode is found in the Postcode to court mapping" do
      RestClient.log = Rails.root.join('log', 'mapit_postcodes.log').to_s
      # Location: http://mapit.service.dsd.io/point/4326/-0.103709,51.452335 => SE24 0NG (Inside the Lambeth Borough Council)
      VCR.use_cassette('postcode_found') do
        court_search = CourtSearch.new('SE240NG', area_of_law: area.name)
        expect(court_search.results.fetch(:found_in_area_of_law)).to eq 1
        expect(court_search.results.fetch(:courts)).to eq [court7]
      end
    end

    context 'when there are multiple courts' do
      # Location:51.451373,-0.106004 (Inside the Lambeth Borough Council)
      let(:court9) do
        VCR.use_cassette('postcode_found') do
          create(:court,
            court_number: 435,
            name: "#{area.name} Court B",
            display: true,
            areas_of_law: [area],
            address_ids: [@visiting_address3.id])
        end
      end

      before(:each) do
        add_local_authorities_to_court local_authorities: [local_authority], court: court9, area_of_law: area
      end

      it 'should return multiple courts sorted by distance' do
        VCR.use_cassette('multiple_courts') do
          court_search = CourtSearch.new('SE240NG', area_of_law: area.name)
          results = court_search.results
          expect(results.fetch(:found_in_area_of_law)).to be > 0
          expect(results.fetch(:courts)).to eq [court7, court9]
          expect(results.fetch(:courts)[0].distance.to_d).to be_within(0.0001).of(3.72484732920979)
          expect(results.fetch(:courts)[1].distance.to_d).to be_within(0.0001).of(3.72484732920979)
        end
      end

      context 'when one of the multiple courts does not have long/lat' do
        it 'should return multiple courts sorted by distance including a court which did not have long/lat' do
          VCR.use_cassette('multiple_courts') do
            court7.update(:longitude, nil)
            court7.update(:latitude, nil)
            court_search = CourtSearch.new('SE240NG', area_of_law: area.name)
            results = court_search.results
            expect(results.fetch(:found_in_area_of_law)).to be > 0
            expect(results.fetch(:courts)).to eq [court9, court7]
            expect(results.fetch(:courts)[0].distance.to_d).to be_within(0.0001).of(3.72484732920979)
            expect(results.fetch(:courts)[1].respond_to?(:distance)).to be_falsey
          end
        end
      end
    end

    context "postcode to court mapping not found" do
      let!(:court10) do
        VCR.use_cassette('postcode_found') do
          create(:court, name: 'The Nearest Court', display: true, areas_of_law: [area],
                         address_ids: [@visiting_address1.id])
        end
      end

      let!(:court11) do
        VCR.use_cassette('postcode_found') do
          create(:court, name: 'Second Nearest Court', display: true, areas_of_law: [area],
                         address_ids: [@visiting_address1.id])
        end
      end

      before(:each) do
        add_local_authorities_to_court local_authorities: [local_authority], court: court10, area_of_law: area
        add_local_authorities_to_court local_authorities: [local_authority], court: court11, area_of_law: area
      end

      it "if the postcode is not found in the Postcode to court mapping, then just default to distance search" do
        VCR.use_cassette('postcode_not_found') do
          court_search = CourtSearch.new('NE128AQ', area_of_law: area.name)
          expect(court_search.results.fetch(:found_in_area_of_law)).to be > 0
          court_search.results.fetch(:courts).should == [court10, court11]
        end
      end
    end
  end
end
