require 'spec_helper'

describe Courtfinder::Application.config do
  it "sets cookie only on the /admin path" do
    subject.session_store.should == ActionDispatch::Session::CookieStore
    subject.session_options.slice(:cookie_only, :key, :path, :httponly).should == { cookie_only: true, key: 'CFSID', path: '/admin', httponly: true }
  end
end
