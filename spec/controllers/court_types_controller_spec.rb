require 'spec_helper'

describe CourtTypesController do
  render_views

  before :each do
    @court_type = CourtType.create!
    controller.should_receive(:set_page_expiration)
  end

  it "displays a list of court types" do
    get :index
    response.should be_success
  end

  it "displays a particular court type" do
    get :show, id: @court_type.id
    response.should be_success
  end
end
