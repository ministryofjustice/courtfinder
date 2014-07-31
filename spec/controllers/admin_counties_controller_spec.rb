require 'spec_helper'

describe Admin::CountiesController do
  render_views

  before :each do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  it "purges the cache when an object is updated" do
    object = County.create!
    controller.should_receive(:purge_all_pages)
    post :update, id: object.id, county: {}
    response.should redirect_to(edit_admin_county_path(object))
  end

  it "purges the cache when a new object is created" do
    expect {
      controller.should_receive(:purge_all_pages)
      post :create, county: {}
      response.should redirect_to(edit_admin_county_path(assigns(:county)))
    }.to change { County.count }.by(1)
  end

  it "purges the cache when an object is destroyed" do
    object = County.create!
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: object.id
      response.should redirect_to(admin_counties_path)
    }.to change { County.count }.by(-1)
  end
end
