require 'spec_helper'


describe CourtFacility do

  describe 'gov uk pushable' do
    let(:court)           { create(:court) }
    let(:facility)        { create(:facility) }
    let(:court_facility)  { create(:court_facility, facility: facility, court: court) }

    it 'should register a gov uk update job on update' do
      court_facility
      GovUkPushWorker.should_receive(:perform_async).with(action: :update, court_id: court_facility.court_id)
      court_facility.update_attribute(:description, 'xxxx')
    end

    it 'should register a gov uk update job on create' do
      court
      facility
      GovUkPushWorker.should_receive(:perform_async).with(action: :update, court_id: court.id)
      court_facility
    end

    it 'should register a gov uk update job on destroy' do
      court_facility
      GovUkPushWorker.should_receive(:perform_async).with(action: :update, court_id: court.id)
      court_facility.destroy
    end    

  end

end