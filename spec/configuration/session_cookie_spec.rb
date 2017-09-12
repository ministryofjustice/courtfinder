require 'spec_helper'

describe Courtfinder::Application.config do
  let(:application_config) { Courtfinder::Application.config }

  it "sets cookie only on the /admin path" do
    expect(application_config.session_store).to eql(ActionDispatch::Session::CookieStore)
    cookie_only = application_config.session_options.slice(:cookie_only, :key, :path, :httponly)
    expect(cookie_only).to eql(cookie_only: true, key: 'CFSID', path: '/admin', httponly: true)
  end
end
