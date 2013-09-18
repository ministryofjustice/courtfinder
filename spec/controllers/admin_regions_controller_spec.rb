require 'spec_helper'

describe Admin::RegionsController do
  render_views

  before :each do
    controller.should_receive(:enable_varnish).never
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  it "purges the cache when an object is updated" do
    object = Region.create!
    controller.should_receive(:purge_all_pages)
    post :update, id: object.id, region: {}
    response.should redirect_to(admin_region_path(object))
  end

  it "purges the cache when a new object is created" do 
    expect {
      controller.should_receive(:purge_all_pages)
      post :create, region: {}
      response.should redirect_to(admin_region_path(assigns(:region)))
    }.to change { Region.count }.by(1)
  end

  it "purges the cache when an object is destroyed" do
    object = Region.create!
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: object.id
      response.should redirect_to(admin_regions_path)
    }.to change { Region.count }.by(-1)
  end
end
