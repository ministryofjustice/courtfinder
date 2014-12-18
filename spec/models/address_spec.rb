require "spec_helper"

describe Address do

  describe 'gov uk pushable' do

    it 'should register a gov uk update job on update' do
      court = create(:court, :name => "London Court")
      address = Address.create( {address_line_1: 'Room 101', town: Town.create!, court: court}, without_protection: true)
      GovUkPushWorker.should_receive(:perform_async).with(action: :update, court_id: court.id)
      address.address_line_2 = 'MOJ'
      address.save
    end

    it 'should register a gov uk update job on create' do
      court = create(:court, :name => "London Court")
      GovUkPushWorker.should_receive(:perform_async).with(action: :update, court_id: court.id)
      address = Address.create( {address_line_1: 'Room 101', town: Town.create!, court: court}, without_protection: true)
    end

    it 'should register a gov uk update job on destroy' do
      court = create(:court, :name => "London Court")
      address = Address.create( {address_line_1: 'Room 101', town: Town.create!, court: court}, without_protection: true)
      GovUkPushWorker.should_receive(:perform_async).with(action: :update, court_id: court.id)
      address.destroy
    end

  end

end