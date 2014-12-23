require 'spec_helper'

describe GovUkPusher do

  describe '#push' do

    let(:court)         { create(:court) }
    let(:pusher)        { GovUkPusher.new(action: :update, court_id: court.id) }
    let(:original_md5)  { '0e6e88dab7f24091a65456e147fdb1d1' }
    let(:new_md5)       { 'fa31c574155c691c4730f24091a65456' }

   

    it 'should not call instantiate the api client if the md5 shows that the update has already been done' do
      Court.any_instance.stub(:gov_uk_md5).and_return(original_md5)

      serializer = CourtSerializer.new(court.id)
      CourtSerializer.any_instance.stub(:md5).and_return(original_md5)
     
      GovUkApiClient.should_not_receive(:new)
      court.should_not_receive(:gov_uk_md5=)
      court.should_not_receive(:gov_uk_updated_at=)
      court.should_not_receive(:public_url=)

      pusher.push
    end
 

    it 'should call instantiate the api client if the md5 hashes are different' do
      client = double GovUkApiClient
      CourtSerializer.any_instance.stub(:md5).and_return(new_md5)
      GovUkApiClient.should_receive(:new).and_return(client)
      client.should_receive(:push)
      client.should_receive(:success?).and_return(true)
      client.should_receive(:public_url)
      
      pusher.push
    end

    it 'should update court record with new values' do
      current_time = Time.now
      Timecop.freeze(current_time) do
        client = double GovUkApiClient
        CourtSerializer.any_instance.stub(:md5).and_return(new_md5)
        GovUkApiClient.should_receive(:new).and_return(client)
        client.should_receive(:push)
        client.should_receive(:success?).and_return(true)
        client.should_receive(:public_url).and_return('http://gov.uk/courts/my-test-court')

        pusher.push

        court.reload
        expect(court.gov_uk_md5).to eq new_md5
        expect(court.gov_uk_updated_at).to eq current_time
        expect(court.public_url).to eq 'http://gov.uk/courts/my-test-court'
      end
    end


    it 'should not update if the client push is unsuccessful' do
      client = double GovUkApiClient
      CourtSerializer.any_instance.stub(:md5).and_return(new_md5)
      GovUkApiClient.should_receive(:new).and_return(client)
      client.should_receive(:push)
      client.should_receive(:success?).and_return(false)
      client.should_receive(:error_message).and_return('XXXXX')

      expect {
        pusher.push
      }.to raise_error RuntimeError, 'Unable to push to gov.uk:  XXXXX'

      reloaded_court = court.reload
      expect(reloaded_court).to eq court
    end


  end


end