require 'spec_helper'

describe Admin::RegionsController do

  before :each do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  describe "#update" do
    let(:region) { Region.new(id: 123) }
    before {
      Region.stub(:find).and_return(region)
      region.stub(id: 123)
    }

    let(:params) { { id: 123, region: { name: 'new region' } } }

    context "that works" do
      before {
        Region.any_instance.stub(update_attributes: true)
      }

      it "redirects to the show path" do
        patch :update, params
        response.should redirect_to(admin_region_path(region))
      end

      it "responds to html" do
        patch :update, params.merge(format: :html)
        expect(response.content_type).to eq('text/html')
      end

      it "responds to json" do
        patch :update, params.merge(format: :json)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "that doesn't work" do
      before {
        Region.any_instance.stub(update_attributes: false)
      }

      context "a html request" do
        before { params[:format] = :html }

        it "rerenders the edit path" do
          patch :update, params
          response.should render_template(:edit)
        end

        it "responds with html" do
          patch :update, params.merge(format: :html)
          expect(response.content_type).to eq('text/html')
        end
      end

      context "a json request" do
        before { params[:format] = :json }
        it "responds to json" do
          patch :update, params.merge(format: :json)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

  end

  describe "#create" do
    let(:params) { { region: { name: 'new region' } } }

    context "that saves ok" do
      it "creates an region" do
        expect {
          post :create, params
        }.to change { Region.count }.by(1)
      end

      it "redirects to the show path" do
        post :create, params
        response.should redirect_to(admin_region_path(assigns(:region)))
      end

      it "responds to html" do
        post :create, params.merge(format: :html)
        expect(response.content_type).to eq('text/html')
      end

      it "responds to json" do
        post :create, params.merge(format: :json)
        expect(response.content_type).to eq('application/json')
      end
    end
    context "that doesn't save ok" do
      before { Region.any_instance.stub(save: false) }

      it "does not create an region" do
        expect {
          post :create, params
        }.to_not change { Region.count }
      end

      it "rerenders the new template" do
        post :create, params
        response.should render_template(:new)
      end

      it "responds to html" do
        post :create, params.merge(format: :html)
        expect(response.content_type).to eq('text/html')
      end

      describe "a json request" do
        it "responds with json" do
          post :create, params.merge(format: :json)
          expect(response.content_type).to eq('application/json')
        end

        it "returns unprocessable_entity status" do
          post :create, params.merge(format: :json)
          expect(response.status).to eq(422)
        end
      end
    end
  end

  it "remove region on destroy" do
    at = Region.create!
    expect {
      post :destroy, id: at.id
      response.should redirect_to(admin_regions_path)
    }.to change { Region.count }.by(-1)
  end

  describe "#index" do
    it "assigns all regions to @regions" do
      get :index
      expect(assigns[:regions]).to eq(Region.all)
    end

    it "responds to html" do
      get :index, format: :html
      expect(response.content_type).to eq('text/html')
    end

    it "responds to json" do
      get :index, format: :json
      expect(response.content_type).to eq('application/json')
    end
  end

  describe "#show" do
    let(:mock_region) { Region.new(id: 123, name: 'mock region') }
    before {
      Region.stub(:find).and_return(mock_region)
    }

    it "gets the right region" do
      Region.should_receive(:find).with('123').and_return(mock_region)
      get :show, id: 123
    end

    it "assigns the region" do
      get :show, id: 123
      expect(assigns[:region]).to eq(mock_region)
    end

    it "responds to html" do
      get :show, id: 123, format: :html
      expect(response.content_type).to eq('text/html')
    end

    it "responds to json" do
      get :show, id: 123, format: :json
      expect(response.content_type).to eq('application/json')
    end
  end

  describe "#new" do

    it "assigns a new region" do
      get :new
      expect(assigns[:region]).to be_a(Region)
    end

    it "responds to html" do
      get :new, format: :html
      expect(response.content_type).to eq('text/html')
    end

    it "responds to json" do
      get :new, format: :json
      expect(response.content_type).to eq('application/json')
    end
  end

  describe "#edit" do
    let(:mock_region) { Region.new(id: 123, name: 'mock region') }
    before {
      Region.stub(:find).and_return(mock_region)
    }

    it "gets the right region" do
      Region.should_receive(:find).with('123').and_return(mock_region)
      get :edit, id: 123
    end
  end

end
