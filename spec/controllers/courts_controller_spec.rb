require 'spec_helper'

describe CourtsController do
  render_views

  before :all do
    @court = Court.create!(:name => 'A court of LAW')
  end

  before :each do
    controller.should_receive(:set_page_expiration)
  end

  it "a list of courts" do
    get :index
    response.should be_successful
  end

  it "redirects to a slug of a particular court" do
    get :show, id: @court.id
    response.should redirect_to(court_path(@court))
  end

  it "displays a particular court" do
    get :show, id: @court.slug
    response.should be_successful
  end

  it "redirects to a slug of a defence leaflet" do
    get :defence, id: @court.id
    response.should redirect_to(defence_path(@court))
  end

  it "displays a defence leaflet" do
    get :defence, id: @court.slug
    response.should be_successful
  end
  
  it "redirects to a slug of a prosecution leaflet" do
    get :prosecution, id: @court.id
    response.should redirect_to(prosecution_path(@court))
  end

  it "displays a prosecution leaflet" do
    get :prosecution, id: @court.slug
    response.should be_successful
  end

  it "redirects to a slug of an information leaflet" do
    get :information, id: @court.id
    response.should redirect_to(information_path(@court))
  end

  it "displays a court information leaflet" do
    get :information, id: @court.slug
    response.should be_successful
  end


  # JSON API

  it "returns information if asked for json" do
    get :show, id: @court.slug, format: :json
    response.should be_successful
  end

  it "json api returns correct information" do
    get :show, id: @court.slug, format: :json
    JSON.parse(response.body).should == {"@context"=>{"@vocab"=>"http://schema.org/"}, "@id"=>"http://test.host/courts/a-court-of-law.json/a-court-of-law", "name"=>"A court of LAW", "@type"=>["GovernmentOrganization", "Courthouse"]}
  end

  it "json api returns correct extra information" do
    @court.update_attributes(:info => 'some information')
    get :show, id: @court.slug, format: :json
    JSON.parse(response.body).should == {"@context"=>{"@vocab"=>"http://schema.org/"}, "@id"=>"http://test.host/courts/a-court-of-law.json/a-court-of-law", "name"=>"A court of LAW", "@type"=>["GovernmentOrganization", "Courthouse"], "description"=>"some information"}
  end
end
