require 'spec_helper'

describe CourtsController do
  render_views

  before :each do
    @ct_magistrate = create(:court_type, :name => "Magistrates' Court")
    @ct_county = create(:court_type, :name => "County Court", :id => 31) # needed to add ID as it's used in model method

    @court = create(:court, :name => 'A court of LAW').reload
  end

  before :each do
    controller.should_receive(:enable_varnish).at_least(1)
  end

  context "enable_varnish" do
    it "calls set_cache_control" do
      # This isn't great.
      controller.should_receive(:set_cache_control).with(@court.updated_at.to_time).once
      get :show, id: @court.id
    end
  end

  context "a list of courts" do
    before :each do
      controller.should_receive(:set_cache_control).with(@court.updated_at).once
      controller.should_receive(:set_vary_accept).once
    end

    it "displays a list of courts" do
      get :index
      response.should be_successful
    end
  end

  context "a court exists" do
    before :each do
      @at_visiting = create(:address_type, :name => "Visiting")
      @at_postal = create(:address_type, :name => "Postal")
      @town = create(:town, :name => "London")
      @ct_family = create(:court_type, :name => "Family Proceedings Court")
      @ct_tribunal = create(:court_type, :name => "Tribunal")
      @ct_crown = create(:court_type, :name => "Crown Court")

      @visiting_address = create(:address, :address_line_1 => "Some street", :postcode => "CR0 2RB", :address_type_id => @at_visiting.id, :town_id => @town.id)
      @postal_address = create(:address, :address_line_1 => "Some other street", :address_type_id => @at_postal.id, :town_id => @town.id)

      VCR.use_cassette('postcode_found') do
        @county_court = create(:court, :name => 'And Justice For All County Court',
                                           :info_leaflet => "some useful info",
                                           :court_type_ids => [@ct_county.id], :display => true,
                                           :address_ids => [@visiting_address.id, @postal_address.id])
      end
      @family_court = create(:court, :name => 'Capita Family Court',
                                         :info_leaflet => "some useful info",
                                         :court_type_ids => [@ct_family.id], :display => true)
      @tribunal = create(:court, :name => 'Capita Tribunal',
                                     :info_leaflet => "some useful info",
                                     :court_type_ids => [@ct_tribunal.id], :display => true)
      @magistrates_court = create(:court, :name => 'Capita Magistrates Court',
                                              :info_leaflet => "some useful info",
                                              :court_type_ids => [@ct_magistrate.id], :display => true)
      @crown_court = create(:court, :name => 'Capita Crown Court',
                                        :info_leaflet => "some useful info",
                                        :court_type_ids => [@ct_crown.id], :display => true) do |court|
        court.addresses.create(:address_line_1 => "Some other street", :address_type_id => @at_postal.id, :town_id => @town.id)
      end
      @combined_court = create(:court, :name => 'Capita Combined Court',
                                           :info_leaflet => "some useful info",
                                           :court_type_ids => [@ct_county.id, @ct_crown.id], :display => true)
      @typeless_court = create(:court, :name => 'Capita Typeless Court',
                                           :info_leaflet => "some useful info",
                                           :display => true, :latitude => 50.0, :longitude => 0.0)
    end

    it "should set a vary header" do
      controller.should_receive(:set_vary_accept)
      get :show, id: @tribunal.slug
    end

    it "redirects to a slug of a particular court" do
      get :show, id: @county_court.id
      response.should redirect_to(court_path(@county_court))
    end

    it "displays a particular court" do
      get :show, id: @county_court.slug
      response.should be_successful
    end

    pending "groups multiple phone numbers of the same type for a court on one line" do
      #Need a better way to test the full string joining two numbers with or
      @county_court.contacts.create(telephone: "0800 800 8080")
      @county_court.contacts.create(telephone: "0800 800 8081")
      get :show, id: @county_court.slug
      expect(response.body).to match /Phone/m
      expect(response.body).to match /0800 800 8081/m
      expect(response.body).to match /a> or <a href/m
      expect(response.body).to match /0800 800 8080/m
    
    end

    context "map" do
      it "displays a map for a court which has latitude, longitude and a visiting address" do
        get :show, id: @county_court.slug
        expect(response.body).to match /Location of the building/m
      end

      it "does not display a map for a court which doesn't have a visiting address" do
        get :show, id: @crown_court.slug
        expect(response.body).not_to match /Location of the building/m
      end
    end

    context "MCOL PCOL help text" do
      it "displays MCOL and PCOL help text" do
        get :show, id: @county_court.slug
        expect(response.body).to match /Money claims/m
      end

      it "does not display MCOL and PCOL help text" do
        get :show, id: @crown_court.slug
        expect(response.body).not_to match /Money claims/m
      end
    end

    context "leaflets" do
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

      context "county courts leaflets" do
        it "displays link to information leaflet for County courts" do
          get :show, id: @county_court.slug
          expect(response.body).to match /Visitor information/m
        end

        it "does not display link to prosecution witness leaflet for County courts" do
          get :show, id: @county_court.slug
          expect(response.body).not_to match /Prosecution witness/m
        end

        it "does not display link to defence witness leaflet for County courts" do
          get :show, id: @county_court.slug
          expect(response.body).not_to match /Defence witness/m
        end

        it "does not display link to juror leaflet for County courts" do
          get :show, id: @county_court.slug
          expect(response.body).not_to match /Juror/m
        end
      end

      context "crown courts leaflets" do
        it "displays link to local sinformation leaflet for Crown courts" do
          get :show, id: @crown_court.slug
          expect(response.body).to match /Visitor information/m
        end

        it "displays link to prosecution witness leaflet for Crown courts" do
          get :show, id: @crown_court.slug
          expect(response.body).to match /Prosecution witness/m
        end

        it "displays link to defence witness leaflet for Crown courts" do
          get :show, id: @crown_court.slug
          expect(response.body).to match /Defence witness/m
        end

        it "displays link to juror leaflet for Crown courts" do
          get :show, id: @crown_court.slug
          expect(response.body).to match /Juror/m
        end
      end

      context "magistrates courts leaflets" do
        it "displays link to information leaflet for Magistrates courts" do
          get :show, id: @magistrates_court.slug
          expect(response.body).to match /Visitor information/m
        end

        it "displays link to prosecution witness leaflet for Magistrates courts" do
          get :show, id: @magistrates_court.slug
          expect(response.body).to match /Prosecution witness/m
        end

        it "displays link to defence witness leaflet for Magistrates courts" do
          get :show, id: @magistrates_court.slug
          expect(response.body).to match /Defence witness/m
        end

        it "does not display link to juror leaflet for Magistrates courts" do
          get :show, id: @magistrates_court.slug
          expect(response.body).not_to match /Juror/m
        end
      end

      context "tribunals leaflets" do
        it "displays link to information leaflet for Tribunals" do
          get :show, id: @tribunal.slug
          expect(response.body).to match /Visitor information/m
        end

        it "does not display link to prosecution witness leaflet for Tribunals" do
          get :show, id: @tribunal.slug
          expect(response.body).not_to match /Prosecution witness/m
        end

        it "does not display link to defence witness leaflet for Tribunals" do
          get :show, id: @tribunal.slug
          expect(response.body).not_to match /Defence witness/m
        end

        it "does not display link to juror leaflet for Tribunals" do
          get :show, id: @tribunal.slug
          expect(response.body).not_to match /Juror/m
        end
      end

      context "typeless court leaflets" do
        it "displays link to information leaflet for courts without types" do
          get :show, id: @typeless_court.slug
          expect(response.body).to match /Visitor information/m
        end

        it "displays link to prosecution witness leaflet for courts without types" do
          get :show, id: @typeless_court.slug
          expect(response.body).to match /Prosecution witness/m
        end

        it "displays link to defence witness leaflet for courts without types" do
          get :show, id: @typeless_court.slug
          expect(response.body).to match /Defence witness/m
        end

        it "does not display link to juror leaflet for courts without types" do
          get :show, id: @typeless_court.slug
          expect(response.body).not_to match /Juror/m
        end
      end

      context "combined courts leaflets" do
        it "displays link to information leaflet for Combined courts" do
          get :show, id: @combined_court.slug
          expect(response.body).to match /Visitor information/m
        end

        it "displays link to prosecution witness leaflet for Combined courts" do
          get :show, id: @combined_court.slug
          expect(response.body).to match /Prosecution witness/m
        end

        it "displays link to defence witness leaflet for Combined courts" do
          get :show, id: @combined_court.slug
          expect(response.body).to match /Defence witness/m
        end

        it "displays link to juror leaflet for Combined courts (with crown court type)" do
          get :show, id: @combined_court.slug
          expect(response.body).to match /Juror/m
        end
      end
    end

    context "API" do
      it "returns a list of courts suitable for autocompletion" do
        get :index, format: :json, compact: 1
        response.should be_successful
        response.content_type.should == 'application/json'

        request.env['HTTP_IF_MODIFIED_SINCE'] = response['Last-Modified']
        get :index, {format: :json, compact: 1}
        response.status.should == 304
      end

      it "returns information if asked for json" do
        get :show, id: @court.slug, format: :json
        response.should be_successful
      end

      it "json api returns correct information" do
        get :show, id: @court.slug, format: :json
        JSON.parse(response.body).should == {"@context"=>{"@vocab"=>"http://schema.org/"}, 
                                              "@id"=>"/courts/a-court-of-law",
                                              "name"=>"A court of LAW", 
                                              "@type"=>["Courthouse"]}
      end

      it "json api returns correct extra information" do
        @court.update_attributes(:info => 'some information')
        get :show, id: @court.slug, format: :json
        JSON.parse(response.body).should == {"@context"=>{"@vocab"=>"http://schema.org/"}, 
                                              "@id"=>"/courts/a-court-of-law",
                                              "name"=>"A court of LAW", 
                                              "@type"=>["Courthouse"], 
                                              "description"=>"some information"}
      end

      it "doesn't return an error if a court's town has no county or no image_file_url" do
        @visiting = create(:address_type, :name => "Visiting")
        @town = create(:town, :name => "London")
        @court1 = create(:court, :slug => "blah", :name => 'County Court', :display => true) do |court|
          @visiting_address = court.addresses.create(:address_line_1 => "Some street", :address_type_id => @visiting.id, :town_id => @town.id)
        end
        get :show, id: @court1.slug, format: :json
        response.should be_successful
      end
    end
  
    context "CSV" do
      it "returns information if asked for CSV" do
        get :index, format: :csv
        response.should be_successful
      end

      it "csv api returns correct information" do
        get :index, format: :csv
        response.body.should == "url,name,image,latitude,longitude,postcode,town,address,phone contacts,email contacts,opening times\n"\
                                "/courts/a-court-of-law,A court of LAW,,,,,,,,,\n"\
                                "/courts/and-justice-for-all-county-court,And Justice For All County Court,,51.37831481703049,-0.1017849333816599,,London,Some other street,,,\n"\
                                "/courts/capita-combined-court,Capita Combined Court,,,,,,,,,\n"\
                                "/courts/capita-crown-court,Capita Crown Court,,,,,London,Some other street,,,\n"\
                                "/courts/capita-family-court,Capita Family Court,,,,,,,,,\n"\
                                "/courts/capita-magistrates-court,Capita Magistrates Court,,,,,,,,,\n"\
                                "/courts/capita-tribunal,Capita Tribunal,,,,,,,,,\n"\
                                "/courts/capita-typeless-court,Capita Typeless Court,,,,,,,,,\n"
      end
    end
  end
end
