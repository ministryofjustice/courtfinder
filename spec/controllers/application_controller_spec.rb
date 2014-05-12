require 'spec_helper'

describe ApplicationController do
  it "enables varnish" do
    setup_controller_request_and_response
    controller.should_receive(:headers).and_return(headers = mock('headers'))
    headers.should_receive(:[]=).with('X-Varnish-Enable', '1')

    controller.enable_varnish
  end

  it "sets the page freshness" do
    setup_controller_request_and_response
    controller.should_receive(:fresh_when).with(last_modified: timestamp = Time.now, public: true).once
    controller.set_cache_control(timestamp)
  end
end
