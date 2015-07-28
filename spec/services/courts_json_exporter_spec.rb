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
      [
        'addresses',
        'updated_at',
        'admin_id',
        'facilities',
        'lat',
        'slug',
        'opening_times',
        'court_types',
        'name',
        'contacts',
        'created_at',
        'court_number',
        'lon',
        'postcodes',
        'emails',
        'areas_of_law',
        'display'
      ]
    end

    it 'has the expected keys' do
      courts_hash.each do |hash|
        expect(hash.keys & expected_keys).to eq(expected_keys)
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
end
