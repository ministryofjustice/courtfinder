require 'spec_helper'

describe RegionsController do
  render_views

  before :each do
    @region = Region.create!(name: 'hobbiton').reload
    controller.should_receive(:set_vary_accept).once
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
