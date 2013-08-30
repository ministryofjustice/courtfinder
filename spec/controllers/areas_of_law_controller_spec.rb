require 'spec_helper'

describe AreasOfLawController do
  render_views

  before :each do
    controller.should_receive(:set_page_expiration)
    @area = AreaOfLaw.create!
  end

  it "displays a list of areas of law" do
    get :index
    response.should be_success
  end

  it "displays a particular area of law" do
    get :show, id: @area.id
    response.should be_success
  end
end
