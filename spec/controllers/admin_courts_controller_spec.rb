require 'spec_helper'

describe Admin::CourtsController do
  render_views

  before :each do
    controller.should_receive(:enable_varnish).never
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  it "displays a list of courts" do
    get :index
    response.should render_template('admin/courts/index')
    response.should be_success
  end

  it "purges the cache when a court is updated" do
    court = Court.create!(name: 'A court of Law')
    controller.should_receive(:purge_all_pages)
    post :update, id: court.id, court: { name: 'Another court of law' }
    response.should redirect_to(edit_admin_court_path(court.reload))
  end

  it "purges the cache when a new court is created" do
    expect {
      controller.should_receive(:purge_all_pages)
      post :create, court: { name: 'A court of LAW' }
      response.should redirect_to(edit_admin_court_path(assigns(:court)))
    }.to change { Court.count }.by(1)
  end

  it "purges the cache when a court is destroyed" do
    court = Court.create!(name: 'A court of Law')
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: court.id
      response.should redirect_to(admin_courts_path)
    }.to change { Court.count }.by(-1)
  end
end
