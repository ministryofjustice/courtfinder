require 'spec_helper'

describe Admin::CountiesController do
  before :each do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end


  describe "#update" do
    let(:county){ County.new(id: 123) }
    before{
      County.stub(:find).and_return(county)
      county.stub(id: 123)
    }

    let(:params){ { id: 123, county: {name: 'new contact type'} } }

    context "that works" do
      before{
        County.any_instance.stub(update_attributes: true)
      }

      it "redirects to the edit path" do
        patch :update, params
        response.should redirect_to(edit_admin_county_path(county))
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
      before{
        County.any_instance.stub(update_attributes: false)
      }

      context "a html request" do
        before{ params[:format] = :html }

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
        before{ params[:format] = :json }
        it "responds to json" do
          patch :update, params.merge(format: :json)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

  end

  describe "#create" do
    let(:params){ { county: {name: 'new contact type'} } }

    context "that saves ok" do
      it "creates an contact type" do
        expect{
          post :create, params
        }.to change { County.count }.by(1)
      end

      it "redirects to the edit path" do
        post :create, params
        response.should redirect_to(edit_admin_county_path(assigns(:county)))
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
      before{ County.any_instance.stub(save: false) }

      it "does not create an contact type" do
        expect{
          post :create, params
        }.to_not change { County.count }
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

  it "remove county on destroy" do
    at = County.create!
    expect {
      post :destroy, id: at.id
      response.should redirect_to(admin_counties_path)
    }.to change { County.count }.by(-1)
  end

  describe "#index" do
    it "assigns all counties to @counties" do
      get :index
      expect(assigns[:counties]).to eq(County.all)
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
    let(:mock_county){ County.new(id: 123, name: 'mock contact type') }
    before{
      County.stub(:find).and_return(mock_county)
    }

    it "gets the right county" do
      County.should_receive(:find).with('123').and_return(mock_county)
      get :show, id: 123
    end

    it "assigns the county" do
      get :show, id: 123
      expect(assigns[:county]).to eq(mock_county)
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

    it "assigns a new county" do
      get :new
      expect(assigns[:county]).to be_a(County)
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
    let(:mock_county){ County.new(id: 123, name: 'mock contact type') }
    before{
      County.stub(:find).and_return(mock_county)
    }

    it "gets the right county" do
      County.should_receive(:find).with('123').and_return(mock_county)
      get :edit, id: 123
    end
  end

end
