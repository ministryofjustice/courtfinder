require 'spec_helper'

describe Admin::ApplicationController do
  before :each do
    setup_controller_request_and_response
  end

  it "tells varnish to purge its cache based on a location" do
    Varnish::Client.any_instance.should_receive(:ban).with(location = '/some.location')
    controller.purge_cache(location)
  end

  it "tells varnish to purge its cache based on a regexp" do
    Varnish::Client.any_instance.should_receive(:purge).with(regex = /^.*$/)
    controller.purge_cache(regex)
  end

  it "tells varnish to purge all pages" do
    controller.should_receive(:purge_cache).with(/.*/)
    controller.purge_all_pages
  end
end
