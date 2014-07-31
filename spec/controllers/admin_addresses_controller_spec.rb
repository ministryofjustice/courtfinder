require 'spec_helper'

describe Admin::AddressesController do
  render_views

  before :each do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  it "purges the cache when a address is updated" do
    at = Address.create!(address_line_1: 'Room 101', town: Town.create!)
    controller.should_receive(:purge_all_pages)
    post :update, id: at.id, address: {}
    response.should redirect_to(admin_address_path(at))
  end

  it "purges the cache when a new address is created" do
    t = Town.create!
    expect {
      controller.should_receive(:purge_all_pages)
      post :create, address: {address_line_1: 'Room 101', town_id: t.id}
      response.should redirect_to(admin_address_path(assigns(:address)))
    }.to change { Address.count }.by(1)
  end

  it "purges the cache when a address is destroyed" do
    at = Address.create!(address_line_1: 'Room 101', town: Town.create!)
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: at.id
      response.should redirect_to(admin_addresses_path)
    }.to change { Address.count }.by(-1)
  end
end
