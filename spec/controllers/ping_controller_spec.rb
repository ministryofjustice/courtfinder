require 'spec_helper'

RSpec.describe PingController, type: :controller do
  
  describe '#index' do
    it "returns valid json" do
      get :index, format: :json
      expect{JSON.parse(response.body)}.to_not raise_error
    end

    describe 'the returned json hash' do

      let(:data){ JSON.parse(response.body) }

      it 'has version_number' do
        get :index, format: :json
        expect(data['version_number']).to_not be_nil
      end
      describe 'version_number key' do
        it 'is the value of Deployment.version_number' do
          allow(Deployment).to receive(:version_number).and_return 'my app version'
          get :index, format: :json 
          expect(data['version_number']).to eq('my app version')
        end
      end

      it 'has build_date' do
        get :index, format: :json
        expect(data['build_date']).to_not be_nil
      end
      describe 'build_date key' do
        it 'is the value of Deployment.build_date' do
          allow(Deployment).to receive(:build_date).and_return 'my build date'
          get :index, format: :json 
          expect(data['build_date']).to eq('my build date')
        end
      end

      it 'has commit_id' do
        get :index, format: :json 
        expect(data['commit_id']).to_not be_nil
      end
      describe 'commit_id key' do
        it 'is the value of Deployment.commit_id' do
          allow(Deployment).to receive(:commit_id).and_return 'my commit id'
          get :index, format: :json 
          expect(data['commit_id']).to eq('my commit id')
        end
      end

      it 'has build_tag' do
        get :index, format: :json
        expect(data['build_tag']).to_not be_nil
      end
      describe 'build_tag key' do
        it 'is the value of Deployment.build_tag' do
          allow(Deployment).to receive(:build_tag).and_return 'my build tag'
          get :index, format: :json 
          expect(data['build_tag']).to eq('my build tag')
        end
      end
      
    end

  end
end