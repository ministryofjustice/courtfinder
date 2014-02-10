require 'spec_helper'

describe Admin::CourtsController do
  render_views

  before :each do
    controller.should_receive(:enable_varnish).never
    @user = User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
    sign_in @user
    @court = Court.create!(name: 'A court of Law')    
  end

  it "displays a list of courts" do
    get :index
    response.should render_template('admin/courts/index')
    response.should be_success
  end

  it "purges the cache when a court is updated" do
    controller.should_receive(:purge_all_pages)
    post :update, id: @court.id, court: { name: 'Another court of law' }
    response.should redirect_to(edit_admin_court_path(@court.reload))
  end

  it "purges the cache when a new court is created" do
    expect {
      controller.should_receive(:purge_all_pages)
      post :create, court: { name: 'A court of LAW' }
      response.should redirect_to(edit_admin_court_path(assigns(:court)))
    }.to change { Court.count }.by(1)
  end

  it "purges the cache when a court is destroyed" do
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: @court.id
      response.should redirect_to(admin_courts_path)
    }.to change { Court.count }.by(-1)
  end



  context "Audit" do
    before do
      PaperTrail.whodunnit = @user.id
    end

    it "returns the audit trail as a CSV file", :versioning => true do
      get :audit, format: :csv
      response.should be_successful    
    end

    it "audit trail csv returns correct information", :versioning => true do
      @court.update_attributes!(name: "Amazing Court")
      get :audit, format: :csv
      response.body.should include "#{Time.now.utc},lol@biz.info,Amazing Court,name,update,A court of Law,Amazing Court"
    end

    it "does not return the audit trail for a non super-admin user", :versioning => true do
      sign_in User.create!(name: 'notadmin', admin: false, email: 'lolcoin@biz.info', password: 'irrelevant')
      get :audit, format: :csv
      response.should_not be_successful    
    end
  end
end
