require 'spec_helper'

describe CourtsController do
  render_views

  before :all do
    @court = FactoryGirl.create(:court, :name => 'A court of LAW')
    @ct_county = FactoryGirl.create(:court_type, :name => "County Court")
    @ct_family = FactoryGirl.create(:court_type, :name => "Family Proceedings Court")
    @ct_tribunal = FactoryGirl.create(:court_type, :name => "Tribunal")
    @ct_magistrate = FactoryGirl.create(:court_type, :name => "Magistrates' Court")
    @ct_crown = FactoryGirl.create(:court_type, :name => "Crown Court")
    @county_court = FactoryGirl.create(:court, :name => 'And Justice For All County Court', 
                    :info_leaflet => "some useful info",
                    :court_type_ids => [@ct_county.id], :display => true)
    @family_court = FactoryGirl.create(:court, :name => 'Capita Family Court', 
                    :info_leaflet => "some useful info",
                    :court_type_ids => [@ct_family.id], :display => true)
    @tribunal = FactoryGirl.create(:court, :name => 'Capita Tribunal', 
                    :info_leaflet => "some useful info",
                    :court_type_ids => [@ct_tribunal.id], :display => true)
    @magistrates_court = FactoryGirl.create(:court, :name => 'Capita Magistrates Court', 
                    :info_leaflet => "some useful info",
                    :court_type_ids => [@ct_magistrate.id], :display => true)
    @crown_court = FactoryGirl.create(:court, :name => 'Capita Crown Court', 
                    :info_leaflet => "some useful info",
                    :court_type_ids => [@ct_crown.id], :display => true)
    @combined_court = FactoryGirl.create(:court, :name => 'Capita Combined Court', 
                    :info_leaflet => "some useful info",
                    :court_type_ids => [@ct_county.id, @ct_crown.id], :display => true)
    @typeless_court = FactoryGirl.create(:court, :name => 'Capita Typeless Court', 
                    :info_leaflet => "some useful info",
                    :display => true)
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

  #Leaflets
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

  #County courts leaflets
  it "displays link to information leaflet for County courts" do
    get :show, id: @county_court.slug
    expect(response.body).to match /Local information leaflet/m
  end

  it "does not display link to prosecution witness leaflet for County courts" do
    get :show, id: @county_court.slug
    expect(response.body).not_to match /Prosecution witness leaflet/m
  end

  it "does not display link to defence witness leaflet for County courts" do
    get :show, id: @county_court.slug
    expect(response.body).not_to match /Defence witness leaflet/m
  end

  it "does not display link to juror leaflet for County courts" do
    get :show, id: @county_court.slug
    expect(response.body).not_to match /Juror leaflet/m
  end

  #Crown courts leaflets
  it "displays link to local sinformation leaflet for Crown courts" do
    get :show, id: @crown_court.slug
    expect(response.body).to match /Local information leaflet/m
  end

  it "displays link to prosecution witness leaflet for Crown courts" do
    get :show, id: @crown_court.slug
    expect(response.body).to match /Prosecution witness leaflet/m
  end

  it "displays link to defence witness leaflet for Crown courts" do
    get :show, id: @crown_court.slug
    expect(response.body).to match /Defence witness leaflet/m
  end

  it "displays link to juror leaflet for Crown courts" do
    get :show, id: @crown_court.slug
    expect(response.body).to match /Juror leaflet/m
  end

  #Magistrates courts leaflets
  it "displays link to information leaflet for Magistrates courts" do
    get :show, id: @magistrates_court.slug
    expect(response.body).to match /Local information leaflet/m
  end

  it "displays link to prosecution witness leaflet for Magistrates courts" do
    get :show, id: @magistrates_court.slug
    expect(response.body).to match /Prosecution witness leaflet/m
  end

  it "displays link to defence witness leaflet for Magistrates courts" do
    get :show, id: @magistrates_court.slug
    expect(response.body).to match /Defence witness leaflet/m
  end

  it "does not display link to juror leaflet for Magistrates courts" do
    get :show, id: @magistrates_court.slug
    expect(response.body).not_to match /Juror leaflet/m
  end

  #Tribunals leaflets
  it "displays link to information leaflet for Tribunals" do
    get :show, id: @tribunal.slug
    expect(response.body).to match /Local information leaflet/m
  end

  it "does not display link to prosecution witness leaflet for Tribunals" do
    get :show, id: @tribunal.slug
    expect(response.body).not_to match /Prosecution witness leaflet/m
  end

  it "does not display link to defence witness leaflet for Tribunals" do
    get :show, id: @tribunal.slug
    expect(response.body).not_to match /Defence witness leaflet/m
  end

  it "does not display link to juror leaflet for Tribunals" do
    get :show, id: @tribunal.slug
    expect(response.body).not_to match /Juror leaflet/m
  end

  #Typeless courts leaflets
  it "displays link to information leaflet for courts without types" do
    get :show, id: @typeless_court.slug
    expect(response.body).to match /Local information leaflet/m
  end

  it "displays link to prosecution witness leaflet for courts without types" do
    get :show, id: @typeless_court.slug
    expect(response.body).to match /Prosecution witness leaflet/m
  end

  it "displays link to defence witness leaflet for courts without types" do
    get :show, id: @typeless_court.slug
    expect(response.body).to match /Defence witness leaflet/m
  end

  it "does not display link to juror leaflet for courts without types" do
    get :show, id: @typeless_court.slug
    expect(response.body).not_to match /Juror leaflet/m
  end

  #Combined courts leaflets
  it "displays link to information leaflet for Combined courts" do
    get :show, id: @combined_court.slug
    expect(response.body).to match /Local information leaflet/m
  end

  it "displays link to prosecution witness leaflet for Combined courts" do
    get :show, id: @combined_court.slug
    expect(response.body).to match /Prosecution witness leaflet/m
  end

  it "displays link to defence witness leaflet for Combined courts" do
    get :show, id: @combined_court.slug
    expect(response.body).to match /Defence witness leaflet/m
  end

  it "displays link to juror leaflet for Combined courts (with crown court type)" do
    get :show, id: @combined_court.slug
    expect(response.body).to match /Juror leaflet/m
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
