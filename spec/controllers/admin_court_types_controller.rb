require 'spec_helper'

describe Admin::CourtTypesController do
  render_views

  before :each do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  it "purges the cache when an object is updated" do
    object = CourtType.create!
    controller.should_receive(:purge_all_pages)
    patch :update, id: object.id, court_type: {}
    response.should redirect_to(admin_court_type_path(object))
  end

  it "purges the cache when a new object is created" do
    expect do
      controller.should_receive(:purge_all_pages)
      post :create, court_type: {}
      response.should redirect_to(admin_court_type_path(assigns(:court_type)))
    end.to change { CourtType.count }.by(1)
  end

  it "purges the cache when an object is destroyed" do
    object = CourtType.create!
    expect do
      controller.should_receive(:purge_all_pages)
      delete :destroy, id: object.id
      response.should redirect_to(admin_court_types_path)
    end.to change { CourtType.count }.by(-1)
  end
end
