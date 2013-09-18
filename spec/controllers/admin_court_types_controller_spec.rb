require 'spec_helper'

describe Admin::CourtTypesController do
  render_views

  before :each do
    controller.should_receive(:set_page_expiration).never
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  it "purges the cache when a court type is updated" do
    ct = CourtType.create!
    controller.should_receive(:purge_all_pages)
    post :update, id: ct.id, court_type: {}
    response.should redirect_to(edit_admin_court_type_path(ct))
  end

  it "purges the cache when a new court type is created" do
    expect {
      controller.should_receive(:purge_all_pages)
      post :create, court_type: {}
      response.should redirect_to(edit_admin_court_type_path(assigns(:court_type)))
    }.to change { CourtType.count }.by(1)
  end

  it "purges the cache when a court type is destroyed" do
    ct = CourtType.create!
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: ct.id
      response.should redirect_to(admin_court_types_path)
    }.to change { CourtType.count }.by(-1)
  end
end
