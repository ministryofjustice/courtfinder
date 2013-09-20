require 'spec_helper'

describe RegionsController do
  render_views

  before :each do
    @region = Region.create!(name: 'hobbiton')
    controller.should_receive(:enable_varnish)
    controller.should_receive(:set_cache_control).with(@region.updated_at).once
  end

  it "displays a list of regions" do
    get :index
    response.should be_success
  end

  it "displays a particular region by slug" do
    get :show, id: @region.slug
    response.should be_success
  end
end
