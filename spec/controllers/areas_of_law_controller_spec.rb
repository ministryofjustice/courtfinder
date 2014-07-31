require 'spec_helper'

describe AreasOfLawController do
  render_views
  let!(:area){ create(:area_of_law)}

  before :each do
    controller.should_receive(:set_vary_header).once
  end

  it "displays a list of areas of law" do
    get :index
    response.should be_success
  end

  it "displays a particular area of law" do
    get :show, id: area.to_param
    response.should be_success
  end
end
