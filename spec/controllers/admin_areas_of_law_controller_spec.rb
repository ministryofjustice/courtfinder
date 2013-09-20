require 'spec_helper'

describe Admin::AreasOfLawController do
  render_views

  before :each do
    controller.should_receive(:enable_varnish).never
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  it "purges the cache when an area is updated" do
    at = AreaOfLaw.create!
    controller.should_receive(:purge_all_pages)
    post :update, id: at.id, area_of_law: {}
    response.should redirect_to(admin_area_of_law_path(at))
  end

  it "purges the cache when a new area is created" do 
    expect {
      controller.should_receive(:purge_all_pages)
      post :create, area_of_law: {}
      response.should redirect_to(admin_area_of_law_path(assigns(:area_of_law)))
    }.to change { AreaOfLaw.count }.by(1)
  end

  it "purges the cache when an area is destroyed" do
    at = AreaOfLaw.create!
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: at.id
      response.should redirect_to(admin_areas_of_law_path)
    }.to change { AreaOfLaw.count }.by(-1)
  end
end
