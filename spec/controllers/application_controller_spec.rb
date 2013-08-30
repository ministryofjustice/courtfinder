require 'spec_helper'

describe ApplicationController do
  it "sets the appropriate headers via set_page_expiration" do
    setup_controller_request_and_response
    controller.should_receive(:expires_in).with(3.hours, public: true)
    controller.should_receive(:headers).and_return(headers = mock('headers'))
    headers.should_receive(:[]=).with('X-Varnish-Enable', true)
    
    controller.set_page_expiration
  end
end
