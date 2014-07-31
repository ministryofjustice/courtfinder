require 'spec_helper'

describe CourtTypesController do
  render_views

  before :each do
    @court_type = CourtType.create!.reload
    controller.should_receive(:set_vary_accept).twice
  end

  it "displays a list of court types" do
    get :index
    response.should be_success

    request.env['HTTP_IF_MODIFIED_SINCE'] = response['Last-Modified']
    get :index
    response.status.should == 304
  end

  it "displays a particular court type" do
    get :show, id: @court_type.id
    response.should be_success

    request.env['HTTP_IF_MODIFIED_SINCE'] = response['Last-Modified']
    get :show, id: @court_type.id
    response.status.should == 304
  end
end
