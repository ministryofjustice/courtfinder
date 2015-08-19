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
    subject { described_class.new.send(:build_areas_of_law, court) }

    let(:criminal)        { build(:area_of_law, name: 'criminal') }
    let(:family)          { build(:area_of_law, name: 'family') }

    let!(:court)          { create(:court, areas_of_law: []) }
    let!(:southwark)      { create(:local_authority, name: 'Southwark', gss_code: '1234') }
    let!(:lambeth)        { create(:local_authority, name: 'Lambeth', gss_code: '5678') }
    let!(:criminal_remit) { create(:remit, court: court, area_of_law: criminal) }
    let!(:family_remit)   { create(:remit, court: court, area_of_law: family) }

    before do
      southwark.remits << [criminal_remit, family_remit]
      lambeth.remits   << [criminal_remit]
      court.remits     << [criminal_remit, family_remit]
    end

    it { expect(subject.map{ |a| a['name'] }).to match_array(%w(criminal family)) }
    it { expect(subject.map{ |a| a['slug'] }).to match_array(%w(criminal family)) }

    context 'criminal law' do
      let(:jurisdiction) { subject.select{ |al| al['name'] == 'criminal' }.first['local_authorities'] }

      it 'is handled for both Southwark and Lambeth' do
        expect(jurisdiction).to match_array([{name: "Lambeth", gss_code: "5678"}, {name: "Southwark", gss_code: "1234"}])
      end
    end

    context 'family law' do
      let(:jurisdiction) { subject.select{ |al| al['name'] == 'family' }.first['local_authorities'] }

      it 'is only handled for Southwark' do
        expect(jurisdiction).to match_array([{name: "Southwark", gss_code: "1234"}])
      end
    end

  end
end
