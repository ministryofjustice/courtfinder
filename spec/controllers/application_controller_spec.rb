require 'spec_helper'

describe ApplicationController do
  it "sets the page freshness" do
    setup_controller_request_and_response
    controller.should_receive(:fresh_when).with(last_modified: timestamp = Time.now, public: true).once
    controller.set_cache_control(timestamp)
  end
end
