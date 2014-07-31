require 'spec_helper'

describe Admin::AreasOfLawController do
  render_views

  before :each do
    sign_in create(:user, admin: true)
  end

  it "purges the cache when an area is updated" do
    at = create(:area_of_law)
    controller.should_receive(:purge_all_pages)
    post :update, id: at.id, area_of_law: {}
    response.should redirect_to(admin_areas_of_law_path)
  end

  it "purges the cache when a new area is created" do
    expect {
      controller.should_receive(:purge_all_pages)
      post :create, area_of_law: { name: 'New area' }
      response.should redirect_to(admin_areas_of_law_path)
    }.to change { AreaOfLaw.count }.by(1)
  end

  it "purges the cache when an area is destroyed" do
    at = create(:area_of_law)
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: at.id
      response.should redirect_to(admin_areas_of_law_path)
    }.to change { AreaOfLaw.count }.by(-1)
  end
end
