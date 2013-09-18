require 'spec_helper'

describe AreasOfLawController do
  render_views

  before :each do
    controller.should_receive(:enable_varnish)
    @area = AreaOfLaw.create!
  end

  it "displays a list of areas of law" do
    controller.should_receive(:set_cache_control).with(@area.updated_at)
    get :index
    response.should be_success
  end

  it "displays a particular area of law" do
    controller.should_receive(:set_cache_control).with(@area.updated_at)
    get :show, id: @area.id
    response.should be_success
  end
end
