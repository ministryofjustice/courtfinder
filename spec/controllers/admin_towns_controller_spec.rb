require 'spec_helper'

describe Admin::TownsController do
  render_views

  before :each do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  it "purges the cache when an object is updated" do
    object = Town.create!
    controller.should_receive(:purge_all_pages)
    post :update, id: object.id, town: {}
    response.should redirect_to(admin_town_path(object))
  end

  it "purges the cache when a new object is created" do
    expect {
      controller.should_receive(:purge_all_pages)
      post :create, town: {}
      response.should redirect_to(admin_town_path(assigns(:town)))
    }.to change { Town.count }.by(1)
  end

  it "purges the cache when an object is destroyed" do
    object = Town.create!
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: object.id
      response.should redirect_to(admin_towns_path)
    }.to change { Town.count }.by(-1)
  end
end
