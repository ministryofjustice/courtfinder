require 'spec_helper'

describe Admin::AddressTypesController do
  render_views

  before :each do
    controller.should_receive(:set_page_expiration).never
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  it "purges the cache when a address type is updated" do
    at = AddressType.create!
    controller.should_receive(:purge_all_pages)
    post :update, id: at.id, address_type: {}
    response.should redirect_to(edit_admin_address_type_path(at))
  end

  it "purges the cache when a new address type is created" do
    expect {
      controller.should_receive(:purge_all_pages)
      post :create, address_type: {}
      response.should redirect_to(edit_admin_address_type_path(assigns(:address_type)))
    }.to change { AddressType.count }.by(1)
  end

  it "purges the cache when a address type is destroyed" do
    at = AddressType.create!
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: at.id
      response.should redirect_to(admin_address_types_path)
    }.to change { AddressType.count }.by(-1)
  end
end
