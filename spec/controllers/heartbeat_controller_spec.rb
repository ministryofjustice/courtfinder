require 'spec_helper'

RSpec.describe HeartbeatController, type: :controller do

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
