require 'spec_helper'

describe RegionsController do
  render_views

  before :each do
    @region = Region.create!
    controller.should_receive(:set_page_expiration)
  end

  it "displays a list of regions" do
    get :index
    response.should be_success
  end

  it "displays a particular region" do
    get :show, id: @region.id
    response.should be_success
  end
end
