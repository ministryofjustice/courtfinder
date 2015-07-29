require 'spec_helper'

describe CourtsJsonExporter do
  subject { CourtsJsonExporter.new }
  let!(:courts) { create_list(:court, 20) }

  describe '#build_courts_json' do
    it 'produces JSON from the courts hashes' do
      courts = subject.build_courts
      json = subject.build_courts_json
      expect(JSON.parse(json)).to eq(courts)
    end
  end

  describe '#build_courts' do
    let(:courts_hash) { subject.build_courts }
    let(:expected_keys) do
      %w{
          addresses admin_id areas_of_law
          contacts court_number court_types created_at
          display emails facilities lat lon name
          opening_times postcodes slug updated_at
      }
    end

    it 'has the expected keys' do
      courts_hash.each do |hash|
        expect(hash.keys).to match_array(expected_keys)
      end
    end

    it 'has a matching hash for each court' do
      courts_hash.each do |hash|
        court = Court.find(hash['admin_id'])
        expect(court).to_not be_nil
        expect(court.name).to eq(hash['name'])
      end
    end
  end

  describe '#build_areas_of_law' do
    describe 'calls court.area_local_authorities_list' do
      let(:court) { create(:court, areas_of_law: create_list(:area_of_law, 1)) }

      context 'and that returns a string instead of an array' do
          before do
            expect(court).to receive(:area_local_authorities_list).and_return('A string')
          end

        it 'but #build_areas_of_law does not break' do
          expect{ subject.send(:build_areas_of_law, court) }.not_to raise_error
        end
      end  # context 'and it returns a string instead of an array'
    end
  end


end
