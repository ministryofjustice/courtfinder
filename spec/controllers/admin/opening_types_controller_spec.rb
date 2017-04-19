require 'spec_helper'

describe Admin::OpeningTypesController do

  before :each do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  describe "#update" do
    let(:opening_type){ OpeningType.new(id: 123) }
    before{
      OpeningType.stub(:find).and_return(opening_type)
      opening_type.stub(id: 123)
    }

    let(:params){ { id: 123, opening_type: {name: 'new opening type'} } }

    context "that works" do
      before{
        OpeningType.any_instance.stub(update_attributes: true)
      }

      it "redirects to the show path" do
        patch :update, params
        response.should redirect_to(admin_opening_type_path(opening_type))
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
        OpeningType.any_instance.stub(update_attributes: false)
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
    let(:params){ { opening_type: {name: 'new opening type'} } }

    context "that saves ok" do
      it "creates an opening type" do
        expect{
          post :create, params
        }.to change { OpeningType.count }.by(1)
      end

      it "redirects to the show path" do
        post :create, params
        response.should redirect_to(admin_opening_type_path(assigns(:opening_type)))
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
      before{ OpeningType.any_instance.stub(save: false) }

      it "does not create an opening type" do
        expect{
          post :create, params
        }.to_not change { OpeningType.count }
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

  describe "#index" do
    it "assigns all opening_types to @opening_types" do
      get :index
      expect(assigns[:opening_types]).to eq(OpeningType.all)
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
    let(:mock_opening_type){ OpeningType.new(id: 123, name: 'mock opening type') }
    before{
      OpeningType.stub(:find).and_return(mock_opening_type)
    }

    it "gets the right opening_type" do
      OpeningType.should_receive(:find).with('123').and_return(mock_opening_type)
      get :show, id: 123
    end

    it "assigns the opening_type" do
      get :show, id: 123
      expect(assigns[:opening_type]).to eq(mock_opening_type)
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

    it "assigns a new opening_type" do
      get :new
      expect(assigns[:opening_type]).to be_a(OpeningType)
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
    let(:mock_opening_type){ OpeningType.new(id: 123, name: 'mock opening type') }
    before{
      OpeningType.stub(:find).and_return(mock_opening_type)
    }

    it "gets the right opening_type" do
      OpeningType.should_receive(:find).with('123').and_return(mock_opening_type)
      get :edit, id: 123
    end
  end


end
