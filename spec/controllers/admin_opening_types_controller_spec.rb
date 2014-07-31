require 'spec_helper'

describe Admin::OpeningTypesController do
  render_views

  before :each do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  it "purges the cache when an object is updated" do
    object = OpeningType.create!
    controller.should_receive(:purge_all_pages)
    post :update, id: object.id, opening_type: {}
    response.should redirect_to(admin_opening_type_path(object))
  end

  it "purges the cache when a new object is created" do
    expect {
      controller.should_receive(:purge_all_pages)
      post :create, opening_type: {}
      response.should redirect_to(admin_opening_type_path(assigns(:opening_type)))
    }.to change { OpeningType.count }.by(1)
  end

  it "purges the cache when an object is destroyed" do
    object = OpeningType.create!
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: object.id
      response.should redirect_to(admin_opening_types_path)
    }.to change { OpeningType.count }.by(-1)
  end
end
