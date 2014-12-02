require 'spec_helper'

describe AreasOfLawController, pending: 'not used anymore' do
  render_views
  let!(:area){ create(:area_of_law)}

  before :each do
    controller.should_receive(:set_vary_header).once
  end

  xit "displays a list of areas of law" do
    get :index
    response.should be_success
  end

  xit "displays a particular area of law" do
    get :show, id: area.to_param
    response.should be_success
  end
end
