require 'spec_helper'

RSpec.describe HealthCheckController, type: :controller do
  describe '#healthcheck' do
    context 'when a problem exists' do
      before do
        expect(ActiveRecord::Base.connection).to receive(:active?).once.and_raise(PG::ConnectionBad)
        get :healthcheck
      end

      it { expect(response).to have_http_status(:success) }

      let(:expected_response) do
        {
          checks: { database: false },
          ok: false
        }.to_json
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
          checks: { database: true },
          ok: true
        }.to_json
      end

      it { expect(response).to have_http_status(:success) }

      it 'returns the expected response report' do
        get :healthcheck
        expect(response.body).to eq(expected_response)
      end
    end
  end

  describe '#ping' do
    before { get :ping }

    subject { response }

    it { is_expected.to have_http_status(:success) }

    context 'returned schema' do
      let(:keys) { ['version_number', 'build_date', 'commit_id', 'build_tag'] }

      subject { JSON.parse(response.body) }

      it 'matches ping.json schema names' do
        expect(subject.keys).to eq keys
      end

      it 'matches ping.json schema key count' do
        expect(subject.count).to eq 4
      end
    end
  end
end
