shared_examples "a search with area of law" do |area_of_law_name|

  let!(:children) { create(:area_of_law, name: 'Children', type_children: true ) }
  let!(:divorce) { create(:area_of_law, name: 'Divorce', type_divorce: true ) }
  let!(:adoption) { create(:area_of_law, name: 'Adoption', type_adoption: true ) }

  context "Chosen area of law is #{area_of_law_name}" do
  	let!(:area) { AreaOfLaw.find_by_name(area_of_law_name)}

    # Location: http://mapit.mysociety.org/nearest/4326/-0.110768,51449126: SW2 2YH (Inside the Lambeth Borough Council)
    let!(:court7) { create(:court, court_number: 434, name: "#{area.name} Court A", display: true, areas_of_law: [area], latitude: 51.449126, longitude: -0.110768) }
    # Location: http://mapit.mysociety.org/nearest/4326/-0.099868,51451707: SE24 9HN (Southwark Borough Council)
    let!(:court8) { create(:court, name: "The Nearest #{area.name} Court - Southwark Borough Council", display: true, areas_of_law: [area], latitude: 51.451707, longitude: -0.099868) }
    let!(:council) { Council.create(name: 'Lambeth Borough Council') }

    it "should return only one search result if the postcode is found in the Postcode to court mapping" do
      RestClient.log = "#{Rails.root}/log/mapit_postcodes.log"
      # Location: http://mapit.mysociety.org/point/4326/-0.103709,51.452335 => SE24 0NG (Inside the Lambeth Borough Council)
      VCR.use_cassette('postcode_found') do
        court_search = CourtSearch.new('SE240NG', {:area_of_law => area.name})
        expect(court_search.results).to eq [court7]
      end
    end

    before(:each) do
      court7.court_council_links.create({council_id: council.id, area_of_law_id: area.id })
    end

    it "should return only one search result if the postcode is found in the Postcode to court mapping" do
      RestClient.log = "#{Rails.root}/log/mapit_postcodes.log"
      # Location: http://mapit.mysociety.org/point/4326/-0.103709,51.452335 => SE24 0NG (Inside the Lambeth Borough Council)
      VCR.use_cassette('postcode_found') do
        court_search = CourtSearch.new('SE240NG', { area_of_law: area.name})
        expect(court_search.results).to eq [court7]
      end
    end

    context 'when there are multiple courts' do
      # Location:51.451373,-0.106004 (Inside the Lambeth Borough Council)
      let(:court9) { create(:court, court_number: 435, name: "#{area} Court B", display: true, areas_of_law: [area], latitude: 51.451373, longitude: -0.106004) }

      it 'should return multiple courts sorted by distance' do
        court9.court_council_links.create({council_id: council.id, area_of_law_id: area.id})

        VCR.use_cassette('multiple_courts') do
          court_search = CourtSearch.new('SE240NG', {area_of_law: area.name})
          results = court_search.results
          expect(results).to eq [court9, court7]
          expect(results[0].distance).to eq "0.16110282696898"
          expect(results[1].distance).to eq "0.418361404378377"
        end
      end
    end

    it "if the postcode is not found in the Postcode to court mapping, then just default to distance search" do
      @court10 = create(:court, name: 'The Nearest Court', display: true, areas_of_law: [area], latitude: 54.337246, longitude: -1.434219)
      @court11 = create(:court, name: 'Second Nearest Court', display: true, areas_of_law: [area], latitude: 54.33724, longitude: -1.43421)
      VCR.use_cassette('postcode_not_found') do
        court_search = CourtSearch.new('NE128AQ', {area_of_law: area.name})
        court_search.results.should == [@court10, @court11]
      end
    end
  end
end