require 'spec_helper'

describe Admin::ContactTypesController do
  render_views

  before :each do
    controller.should_receive(:set_page_expiration).never
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  it "purges the cache when an area is updated" do
    at = ContactType.create!
    controller.should_receive(:purge_all_pages)
    post :update, id: at.id, contact_type: {}
    response.should redirect_to(admin_contact_type_path(at))
  end

  it "purges the cache when a new area is created" do 
    expect {
      controller.should_receive(:purge_all_pages)
      post :create, contact_type: {}
      response.should redirect_to(admin_contact_type_path(assigns(:contact_type)))
    }.to change { ContactType.count }.by(1)
  end

  it "purges the cache when an area is destroyed" do
    at = ContactType.create!
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: at.id
      response.should redirect_to(admin_contact_types_path)
    }.to change { ContactType.count }.by(-1)
  end
end
