require 'spec_helper'

describe Admin::CourtsController do
  before :each do
    @user = User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
    sign_in @user
    @court = create(:court, name: 'A court of Law')
  end

  it "displays a list of courts" do
    get :index
    response.should render_template('admin/courts/index')
    response.should be_success
  end

  describe "#update" do
    let(:params){ {id: @court.id, court: { name: 'Another court of law' }} }

    context "that works" do
      before{
        Court.any_instance.stub(update_attributes: true)
      }
      it "purges the cache" do
        controller.should_receive(:purge_all_pages)
        patch :update, params
      end

      context "a html request" do
        it "redirects to the edit path" do
          patch :update, params
          response.should redirect_to(edit_admin_court_path(@court.reload))
        end
      end
      context "a json request" do
        before{ params[:format] = :json }

        it "responds with no content" do
          patch :update, params
          expect(response.status).to eq(204)
        end
      end
    end

    context "that doesn't work" do
      before{
        Court.any_instance.stub(update_attributes: false)
      }

      it "does not purge the cache" do
        controller.should_not_receive(:patche_all_pages)
        post :update, params
      end

      context "a html request" do
        context "with a redirect_url param" do
          before{ params[:redirect_url] = 'http://some.com'}

          it "redirects to the given redirect_url" do
            patch :update, params
            expect(response).to redirect_to(params[:redirect_url])
          end
        end
        context "without a redirect_url param" do
          it "rerenders the edit template" do
            patch :update, params
            response.should render_template(:edit)
          end
        end
      end
      context "a json request" do
        before{ params[:format] = :json }

        it "responds with unprocessable_entity" do
          patch :update, params
          expect(response.status).to eq(422)
        end
      end
    end
  end

  describe "#create" do
    let(:params){ {court: { name: 'A court of LAW', latitude:50, longitude:0 }} }

    context "that works" do
      it "purges the cache" do
        controller.should_receive(:purge_all_pages)
        put :create, params
      end

      context "a html request" do
        it "redirects to the edit path" do
          put :create, params
          response.should redirect_to(edit_admin_court_path(Court.last))
        end
      end
      context "a json request" do
        before{ params[:format] = :json }

        it "responds with created" do
          put :create, params
          expect(response.status).to eq(201)
        end
      end
    end

    context "that doesn't work" do
      before{
        Court.any_instance.stub(save: false)
      }

      it "does not purge the cache" do
        controller.should_not_receive(:purge_all_pages)
        put :create, params
      end

      context "a html request" do
        it "rerenders the new template" do
          put :create, params
          response.should render_template(:new)
        end
      end
      context "a json request" do
        before{ params[:format] = :json }

        it "responds with unprocessable_entity" do
          put :create, params
          expect(response.status).to eq(422)
        end
      end
    end
  end

  it "purges the cache when a court is destroyed" do
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: @court.id
      response.should redirect_to(admin_courts_path)
    }.to change { Court.count }.by(-1)
  end

  describe "#new" do
    it "assigns a new court to @court" do
      get :new
      expect(assigns[:court]).to be_a(Court)
    end

    describe "a html request" do
      it "responds with html" do
        get :index
        expect(response.content_type).to eq('text/html')
      end

      it "responds with :ok" do
        get :new, format: :html
        expect( response.status ).to eq(200)
      end
    end
    
    describe "a json request" do
      it "responds with json" do
        get :new, format: :json
        expect(response.content_type).to eq('application/json')
      end

      it "responds with :ok" do
        get :new, format: :json
        expect( response.status ).to eq(200)
      end
    end
  end

  describe "#show" do
    let(:court){ Court.create(name: 'My Court') }

    it "finds the right court" do 
      expect(Court).to receive_message_chain(:friendly,:find).with(court.id.to_s).and_return(court)
      get :show, id: court.id
    end

    it "assigns the court" do
      get :show, id: court.id
      expect(assigns[:court]).to eq(court)
    end

    describe "a html request" do
      it "responds with html" do
        get :show, id: court.id, format: :html
        expect(response.content_type).to eq('text/html')
      end

      it "responds with :ok" do
        get :show, id: court.id, format: :html
        expect( response.status ).to eq(200)
      end
    end
    
    describe "a json request" do
      it "responds with json" do
        get :show, id: court.id, format: :json
        expect(response.content_type).to eq('application/json')
      end

      it "responds with :ok" do
        get :show, id: court.id, format: :json
        expect( response.status ).to eq(200)
      end
    end
  end

  describe "#edit" do
    let(:court){ Court.create(name: 'My Court') }

    it "finds the right court" do 
      expect(Court).to receive_message_chain(:friendly, :find).with(court.id.to_s).and_return(court)
      get :edit, id: court.id
    end

    it "assigns the court" do
      get :edit, id: court.id
      expect(assigns[:court]).to eq(court)
    end

    it "assigns the courts contacts in :sort order to @court_contacts" do
      allow(Court).to receive_message_chain(:friendly, :find).and_return(court)
      court.contacts.should_receive(:order).with(:sort).and_return('sorted contacts')
      get :edit, id: court.id
      expect(assigns[:court_contacts]).to eq('sorted contacts')
    end

    describe "a html request" do
      it "responds with html" do
        get :edit, id: court.id, format: :html
        expect(response.content_type).to eq('text/html')
      end

      it "responds with :ok" do
        get :edit, id: court.id, format: :html
        expect( response.status ).to eq(200)
      end
    end
  
  end

  describe "#areas_of_law" do
    let(:mock_courts_by_name){ double('courts by name', paginate: 'paginated courts by name') }
    before{ 
      Court.stub(:by_name).and_return(mock_courts_by_name)
      AreaOfLaw.stub(:all).and_return('all areas of law')
    }
    it "gets one page of courts by name" do
      mock_courts_by_name.should_receive(:paginate).with(page: '1', per_page: 30).and_return 'paginated courts by name'
      get :areas_of_law, page: 1
    end

    it "assigns the paginated courts by name to @courts" do
      get :areas_of_law
      expect(assigns[:courts]).to eq('paginated courts by name')
    end

    it "gets all areas of law" do
      AreaOfLaw.should_receive(:all).and_return('all areas of law')
      get :areas_of_law
    end

    it "assigns all areas of law to @areas_of_law" do
      get :areas_of_law
      expect(assigns[:areas_of_law]).to eq('all areas of law')
    end
  end


  describe "#court_types" do
    let(:mock_courts_by_name){ double('courts by name', paginate: 'paginated courts by name') }
    before{ 
      Court.stub(:by_name).and_return(mock_courts_by_name)
      CourtType.stub(:order).and_return('all court types')
    }
    it "gets one page of courts by name" do
      mock_courts_by_name.should_receive(:paginate).with(page: '1', per_page: 30).and_return 'paginated courts by name'
      get :court_types, page: 1
    end

    it "assigns the paginated courts by name to @courts" do
      get :court_types
      expect(assigns[:courts]).to eq('paginated courts by name')
    end

    it "gets all court types in name order" do
      CourtType.should_receive(:order).with(:name).and_return('all court types')
      get :court_types
    end

    it "assigns all court types to @court_types" do
      get :court_types
      expect(assigns[:court_types]).to eq('all court types')
    end
  end


  describe "#civil" do
    before{
      Court.stub_chain(:by_area_of_law, :by_name, :paginate).and_return('courts')
    }
    it "assigns courts" do
      get :civil
      expect(assigns(:courts)).to eq('courts')
    end
  end

  describe '#family' do

    it 'assigns @courts' do
      family_area = AreaOfLaw.where(name: 'Children').first_or_initialize
      family_area.save
      get :family, { page: 1 }
      expect(assigns(:courts)).to eq(Court.by_area_of_law(['Children','Divorce','Adoption']).by_name.paginate(page: 1, per_page: 30))
    end

    it 'assigns @area_of_law' do
      family_area = AreaOfLaw.where(name: 'Children').first_or_initialize
      family_area.save
      get :family, { area_of_law_id: family_area.id }
      expect(assigns(:area_of_law)).to eq(family_area)
    end

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
      response.body.should include "lol@biz.info,ip,Amazing Court,name,update,A court of Law,Amazing Court"
    end

    it "does not return the audit trail for a non super-admin user", :versioning => true do
      sign_in User.create!(name: 'notadmin', admin: false, email: 'lolcoin@biz.info', password: 'irrelevant')
      get :audit, format: :csv
      response.should_not be_successful
    end
  end
end
