require 'spec_helper'

describe Admin::ApplicationController do
  before :each do
    setup_controller_request_and_response
  end

  describe '#info_for_paper_trail' do

    it 'returns a name for an ip address' do
      ActionDispatch::Request.any_instance.stub(:remote_ip).and_return('1.1.1.1')

      data = controller.send(:info_for_paper_trail)
      expect(data).to include( ip: '1.1.1.1' )
    end


  end
end
