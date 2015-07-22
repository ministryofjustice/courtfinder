require 'spec_helper'

RSpec.describe HeartbeatController, type: :controller do
  describe '#ping' do
    context 'when ping.json file not present' do
      before { get :ping }

      it 'returns an empty result' do
        expect(JSON.parse(response.body)).to eq({})
      end
    end

    context 'when ping.json file present' do
      let(:expected_json) do
        {
          'version_number'  => '123',
          'build_date'      => '20150721',
          'commit_id'       => 'afb12cb3',
          'build_tag'       => 'test'
        }
      end

      before do
        allow(File).to receive(:read).and_return(expected_json.to_json)
        get :ping
      end

      it 'returns JSON with app information' do
        expect(JSON.parse(response.body)).to eq(expected_json)
      end
    end
  end

  describe '#healthcheck' do
    context 'when a problem exists' do
      before(:each) do
        expect(ActiveRecord::Base.connection).to receive(:active?).once.and_raise(PG::ConnectionBad)
        get :healthcheck
      end

      let(:expected_response) do
        {
          checks: { database: false }
        }.to_json
      end

      it 'returns status bad gateway' do
        expect(response.status).to eq(502)
      end

      it 'returns the expected response report' do
        expect(response.body).to eq(expected_response)
      end
    end

    context 'when everything is ok' do
      before do
        get :healthcheck
      end

      let(:expected_response) do
        {
          checks: { database: true }
        }.to_json
      end

      it 'returns HTTP success' do
        get :healthcheck
        expect(response.status).to eq(200)
      end

      it 'returns the expected response report' do
        get :healthcheck
        expect(response.body).to eq(expected_response)
      end
    end
  end
end
