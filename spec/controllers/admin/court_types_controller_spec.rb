require 'spec_helper'

describe Admin::CourtTypesController do

  before :each do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  describe "#update" do
    let(:court_type) { CourtType.new(id: 123) }
    before do
      CourtType.stub(:find).and_return(court_type)
      court_type.stub(id: 123)
    end

    let(:params) { { id: 123, court_type: { name: 'new court type' } } }

    context "that works" do
      before do
        CourtType.any_instance.stub(update_attributes: true)
      end

      it "redirects to the edit path" do
        patch :update, params
        response.should redirect_to(edit_admin_court_type_path(court_type))
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
      before do
        CourtType.any_instance.stub(update_attributes: false)
      end

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
    let(:params) { { court_type: { name: 'new court type' } } }

    context "that saves ok" do
      it "creates an court type" do
        expect do
          post :create, params
        end.to change { CourtType.count }.by(1)
      end

      it "redirects to the show path" do
        post :create, params
        response.should redirect_to(edit_admin_court_type_path(assigns(:court_type)))
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
      before { CourtType.any_instance.stub(save: false) }

      it "does not create an court type" do
        expect do
          post :create, params
        end.to_not change { CourtType.count }
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

  it "removes court_type" do
    at = CourtType.create!
    expect do
      post :destroy, id: at.id
      response.should redirect_to(admin_court_types_path)
    end.to change { CourtType.count }.by(-1)
  end

  describe "#index" do
    let(:ordered_court_types) { double('ordered court types') }
    let(:mock_court_types) { double('all court types', order: ordered_court_types) }

    it "assigns all court_types to @court_types" do
      expect(CourtType).to receive(:all).and_return(mock_court_types)
      get :index
      expect(assigns[:court_types]).to eq(ordered_court_types)
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
    let(:court_type) { CourtType.create!(name: 'mock court type') }
    before do
      CourtType.stub(:find).and_return(court_type)
    end

    it "gets the right court_type" do
      CourtType.should_receive(:find).with(court_type.id.to_s).and_return(court_type)
      get :show, id: court_type.id
    end

    it "assigns the court_type" do
      get :show, id: court_type.id
      expect(assigns[:court_type]).to eq(court_type)
    end

    it "responds to html" do
      get :show, id: court_type.id, format: :html
      expect(response.content_type).to eq('text/html')
    end

    it "responds to json" do
      get :show, id: court_type.id, format: :json
      expect(response.content_type).to eq('application/json')
    end
  end

  describe "#new" do

    it "assigns a new court_type" do
      get :new
      expect(assigns[:court_type]).to be_a(CourtType)
    end

    it "responds to html" do
      get :new, format: :html
      expect(response.content_type).to eq('text/html')
    end

  end

  describe "#edit" do
    let(:mock_court_type) { CourtType.new(id: 123, name: 'mock court type') }
    before do
      CourtType.stub(:find).and_return(mock_court_type)
    end

    it "gets the right court_type" do
      CourtType.should_receive(:find).with('123').and_return(mock_court_type)
      get :edit, id: 123
    end
  end

end
