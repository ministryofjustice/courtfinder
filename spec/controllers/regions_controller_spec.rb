require 'spec_helper'

describe RegionsController do
  render_views

  before :each do
    @region = Region.create!(name: 'hobbiton').reload
    controller.should_receive(:enable_varnish).twice
    controller.should_receive(:set_vary_accept).twice
  end

  it "displays a list of regions" do
    get :index
    response.should be_success

    request.env['HTTP_IF_MODIFIED_SINCE'] = response['Last-Modified']
    get :index
    response.status.should == 304
  end

  it "displays a particular region by slug" do
    get :show, id: @region.slug
    response.should be_success

    request.env['HTTP_IF_MODIFIED_SINCE'] = response['Last-Modified']
    get :show, id: @region.slug
    response.status.should == 304
  end
end
