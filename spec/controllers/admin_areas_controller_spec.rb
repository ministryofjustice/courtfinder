require 'spec_helper'

describe Admin::AreasController do
  render_views

  before :each do
    controller.should_receive(:set_page_expiration).never
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  it "purges the cache when an area is updated" do
    at = Area.create!
    controller.should_receive(:purge_all_pages)
    post :update, id: at.id, area: {}
    response.should redirect_to(edit_admin_area_path(at))
  end

  it "purges the cache when a new area is created" do 
    expect {
      controller.should_receive(:purge_all_pages)
      post :create, area: {}
      response.should redirect_to(edit_admin_area_path(assigns(:area)))
    }.to change { Area.count }.by(1)
  end

  it "purges the cache when an area is destroyed" do
    at = Area.create!
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: at.id
      response.should redirect_to(admin_areas_path)
    }.to change { Area.count }.by(-1)
  end
end
