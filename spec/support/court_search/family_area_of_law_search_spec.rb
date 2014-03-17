shared_examples "a search with area of law" do |area_of_law_name|

  let!(:children) { create(:area_of_law, name: 'Children', type_children: true ) }
  let!(:divorce) { create(:area_of_law, name: 'Divorce', type_divorce: true ) }
  let!(:adoption) { create(:area_of_law, name: 'Adoption', type_adoption: true ) }
  let!(:at_visiting) { create(:address_type, :name => "Visiting") }
  let!(:town) { create(:town, :name => "London") }
  let!(:visiting_address) { create(:address, :address_line_1 => "Some street", 
    :address_type_id => at_visiting.id, :postcode => 'SE19NH', :town_id => town.id) }

  context "Chosen area of law is #{area_of_law_name}" do
  	let!(:area) { AreaOfLaw.find_by_name(area_of_law_name)}
    # Location: http://mapit.mysociety.org/nearest/4326/-0.110768,51449126: SW2 2YH (Inside the Lambeth Borough Council)
    let!(:court7) do 
      VCR.use_cassette('postcode_found') do
        create(:court, court_number: 434, name: "#{area.name} Court A", display: true, areas_of_law: [area], 
                                      :address_ids => [visiting_address.id]) 
      end
    end
    let!(:council) { Council.create(name: 'Lambeth Borough Council') }

    before(:each) do
      court7.court_council_links.create({council_id: council.id, area_of_law_id: area.id })
    end

    it "should return only one search result if the postcode is found in the Postcode to court mapping" do
      RestClient.log = "#{Rails.root}/log/mapit_postcodes.log"
      # Location: http://mapit.mysociety.org/point/4326/-0.103709,51.452335 => SE24 0NG (Inside the Lambeth Borough Council)
      VCR.use_cassette('postcode_found') do
        court_search = CourtSearch.new('SE240NG', {:area_of_law => area.name})
        expect(court_search.results).to eq [court7]
      end
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
      let(:court9) do
        VCR.use_cassette('postcode_found') do
         create(:court, court_number: 435, name: "#{area.name} Court B", display: true, areas_of_law: [area], 
                                          :address_ids => [@visiting_address3.id])
        end
      end

      it 'should return multiple courts sorted by distance' do
        court9.court_council_links.create({council_id: council.id, area_of_law_id: area.id})

        VCR.use_cassette('multiple_courts') do
          court_search = CourtSearch.new('SE240NG', {area_of_law: area.name})
          results = court_search.results
          expect(results).to eq [court7, court9]
          expect(results[0].distance).to eq "3.72484732920979"
          expect(results[1].distance).to eq "3.72484732920979"
        end
      end
    end

    context "postcode to court mapping not found" do
      let!(:court10) do 
        VCR.use_cassette('postcode_found') do
          create(:court, name: 'The Nearest Court', display: true, areas_of_law: [area], 
                                     :address_ids => [@visiting_address1.id])
        end
      end

      let!(:court11) do 
        VCR.use_cassette('postcode_found') do
          create(:court, name: 'Second Nearest Court', display: true, areas_of_law: [area], 
                                     :address_ids => [@visiting_address1.id])
        end
      end

      it "if the postcode is not found in the Postcode to court mapping, then just default to distance search" do
        VCR.use_cassette('postcode_not_found') do
          court_search = CourtSearch.new('NE128AQ', {area_of_law: area.name})
          court_search.results.should == [court10, court11]
        end
      end
    end
  end
end