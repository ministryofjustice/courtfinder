require 'spec_helper'

describe Admin::AreasOfLawController do
  render_views

  before :each do
    sign_in create(:user, admin: true)
  end


  require 'spec_helper'

describe Admin::AreasController do
  render_views

  before :each do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  describe "#index" do
    it "assigns all areas" do
      get :index
      expect(assigns[:areas_of_law]).to eq(AreaOfLaw.all)
    end

    describe "a html request" do
      it "responds with html" do
        get :index
        expect(response.content_type).to eq('text/html')
      end

      it "responds with :ok" do
        get :index
        expect( response.status ).to eq(200)
      end
    end
    
    describe "a json request" do
      it "responds with json" do
        get :index, format: :json
        expect(response.content_type).to eq('application/json')
      end

      it "responds with :ok" do
        get :index, format: :json
        expect( response.status ).to eq(200)
      end
    end
  end

  describe "#update" do
    let(:area){ area_of_law = AreaOfLaw.create!(name: 'the north') }
    let(:params){ {id: area.id, area_of_law: {}} }
      
    context "when it works" do
      before{ area.stub(update_attributes: true) }

      it "purges the cache" do
        controller.should_receive(:purge_all_pages)
        post :update, params
      end

      describe "a html request" do
        before{ params[:format] = :html }

        it "redirects to the index path" do
          post :update, params
          response.should redirect_to(admin_areas_of_law_path)
        end

        it "flashes a notice" do
          post :update, params
          expect(flash[:notice]).to_not be_empty
        end
      end

      describe "a json request" do
        before{ params[:format] = :json }

        it "reponds with json" do
          post :update, params
          expect(response.content_type).to eq('application/json')
        end

        it "responds with no content" do
          post :update, params
          expect(response.status).to eq(204)
        end
      end
    end

    context "when it doesn't work" do
      before{ AreaOfLaw.any_instance.stub(update_attributes: false) }

      it "does not purge the cache" do
        controller.should_not_receive(:purge_all_pages)
        post :update, params
      end

      describe "a html request" do
        before{ params[:format] = :html }

        it "rerenders the edit template" do
          post :update, params
          response.should render_template(:edit)
        end

        it "flashes an error" do
          post :update, params
          expect(flash[:error]).to_not be_empty
        end
      end

      describe "a json request" do
        before{ params[:format] = :json }

        it "reponds with json" do
          post :update, params
          expect(response.content_type).to eq('application/json')
        end

        it "responds with status :unprocessable_entity" do
          post :update, params
          expect(response.status).to eq(422)
        end
      end
    end
  end

  describe "#create" do
    context "that works" do
      let(:params){ {area_of_law: {name: '22 Acacia Avenue'}} }

      it "creates a new Area" do
        expect{ post :create, params }.to change(AreaOfLaw, :count).by(1)
      end

      it "purges the cache" do
        controller.should_receive(:purge_all_pages)
        post :create, params
      end

      describe "a html request" do
        before{ params[:format] = :html }

        it "redirects to the index" do
          post :create, params
          expect(response).to redirect_to(admin_areas_of_law_path)
        end

        it "flashes a notice" do
          post :create, params
          expect(flash[:notice]).to_not be_empty
        end
      end

      describe "a json request" do
        before{ params[:format] = :json }

        it "responds with json" do
          post :create, params
          expect(response.content_type).to eq('application/json')
        end

        it "responds with status :created" do
          post :create, params
          expect(response.status).to eq(201)
        end
      end
      
    end

    context "that doesn't work" do
      let(:params){ {area_of_law: {name: 'something'}}  }
      before{ AreaOfLaw.any_instance.stub(save: false)}

      it "does not create an Area" do
        expect{ post :create, params }.to_not change(AreaOfLaw, :count)
      end

      it "does not purge the cache" do
        controller.should_not_receive(:purge_all_pages)
        post :create, params
      end

      describe "a html request" do
        before{ params[:format] = :html }

        it "re-renders the new template" do
          post :create, params
          expect(response).to render_template(:new)
        end

        it "flashes an error" do
          post :create, params
          expect(flash[:error]).to_not be_empty
        end
      end

      describe "a json request" do
        before{ params[:format] = :json }

        it "responds with json" do
          post :create, params
          expect(response.content_type).to eq('application/json')
        end

        it "responds with status :unprocessable_entity" do
          post :create, params
          expect(response.status).to eq(422)
        end
      end
    end
  end

  describe "#edit" do
    let(:area){ AreaOfLaw.create(name: '22 Acacia Avenue') }

    it "finds the right area" do 
      AreaOfLaw.should_receive(:find).with(area.id.to_s).and_return(area)
      get :edit, id: area.id
    end

    it "assigns the area" do
      get :edit, id: area.id
      expect(assigns[:area_of_law]).to eq(area)
    end
  end

  describe "#new" do
    it "assigns a new area_of_law to @area" do
      get :new
      expect(assigns[:area_of_law]).to be_a(AreaOfLaw)
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
    let(:area){ AreaOfLaw.create(name: 'Somewhere') }

    it "finds the right area" do 
      AreaOfLaw.should_receive(:find).with(area.id.to_s).and_return(area)
      get :show, id: area.id
    end

    it "assigns the area" do
      get :show, id: area.id
      expect(assigns[:area_of_law]).to eq(area)
    end

    describe "a html request" do
      it "responds with html" do
        get :show, id: area.id, format: :html
        expect(response.content_type).to eq('text/html')
      end

      it "responds with :ok" do
        get :show, id: area.id, format: :html
        expect( response.status ).to eq(200)
      end
    end
    
    describe "a json request" do
      it "responds with json" do
        get :show, id: area.id, format: :json
        expect(response.content_type).to eq('application/json')
      end

      it "responds with :ok" do
        get :show, id: area.id, format: :json
        expect( response.status ).to eq(200)
      end
    end
  end

  it "purges the cache when a area_of_law is destroyed" do
    at = AreaOfLaw.create!(name: 'somewhere')
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: at.id
      response.should redirect_to(admin_areas_of_law_path)
    }.to change { AreaOfLaw.count }.by(-1)
  end

end


  it "purges the cache when an area_of_law is destroyed" do
    at = create(:area_of_law)
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: at.id
      response.should redirect_to(admin_areas_of_law_path)
    }.to change { AreaOfLaw.count }.by(-1)
  end
end
