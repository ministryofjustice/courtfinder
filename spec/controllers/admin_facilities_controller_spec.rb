require 'spec_helper'

describe Admin::FacilitiesController do
  render_views

  before :each do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  it "purges the cache when an object is updated" do
    object = Facility.create!
    controller.should_receive(:purge_all_pages)
    post :update, id: object.id, facility: {}
    response.should redirect_to(admin_facility_path(object))
  end

  it "purges the cache when a new object is created" do
    expect {
      controller.should_receive(:purge_all_pages)
      post :create, facility: {}
      response.should redirect_to(admin_facility_path(assigns(:facility)))
    }.to change { Facility.count }.by(1)
  end

  it "purges the cache when an object is destroyed" do
    object = Facility.create!
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: object.id
      response.should redirect_to(admin_facilities_path)
    }.to change { Facility.count }.by(-1)
  end
end
