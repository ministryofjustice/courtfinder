require 'spec_helper'

describe AreasOfLawController do
  render_views

  before :each do
    controller.should_receive(:enable_varnish).twice
    @area = AreaOfLaw.create!.reload
    controller.should_receive(:set_cache_control).with(@area.updated_at).twice.and_call_original
    controller.should_receive(:set_vary_accept).twice
  end

  it "displays a list of areas of law" do
    get :index
    response.should be_success

    request.env['HTTP_IF_MODIFIED_SINCE'] = response['Last-Modified']
    get :index
    response.status.should == 304
  end

  it "displays a particular area of law" do
    get :show, id: @area.id
    response.should be_success

    request.env['HTTP_IF_MODIFIED_SINCE'] = response['Last-Modified']
    get :show, id: @area.id
    response.status.should == 304
  end
end
