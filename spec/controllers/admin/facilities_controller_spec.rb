require 'spec_helper'

describe Admin::FacilitiesController do
  before :each do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  describe "#update" do
    let(:facility){ Facility.new(id: 123) }
    before{
      Facility.stub(:find).and_return(facility)
      facility.stub(id: 123)
    }

    let(:params){ { id: 123, facility: {name: 'new contact type'} } }

    context "that works" do
      before{
        Facility.any_instance.stub(update_attributes: true)
      }

      it "redirects to the show path" do
        patch :update, params
        response.should redirect_to(admin_facility_path(facility))
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
        Facility.any_instance.stub(update_attributes: false)
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
    let(:params){ { facility: { name: 'new contact type', image_file: fixture_file_upload("assets/firstaid.png",'image/png') } } }

    context "that saves ok" do
      it "creates an contact type" do
        expect{
          post :create, params
        }.to change { Facility.count }.by(1)
      end

      it "redirects to the show path" do
        post :create, params
        response.should redirect_to(admin_facility_path(assigns(:facility)))
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
      before{ Facility.any_instance.stub(save: false) }

      it "does not create an contact type" do
        expect{
          post :create, params
        }.to_not change { Facility.count }
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
    it "assigns all facilities to @facilities" do
      get :index
      expect(assigns[:facilities]).to eq(Facility.all)
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
    let(:mock_facility){ Facility.new(id: 123, name: 'mock contact type') }
    before{
      Facility.stub(:find).and_return(mock_facility)
    }

    it "gets the right facility" do
      Facility.should_receive(:find).with('123').and_return(mock_facility)
      get :show, id: 123
    end

    it "assigns the facility" do
      get :show, id: 123
      expect(assigns[:facility]).to eq(mock_facility)
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

    it "assigns a new facility" do
      get :new
      expect(assigns[:facility]).to be_a(Facility)
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
    let(:mock_facility){ Facility.new(id: 123, name: 'mock contact type') }
    before{
      Facility.stub(:find).and_return(mock_facility)
    }

    it "gets the right facility" do
      Facility.should_receive(:find).with('123').and_return(mock_facility)
      get :edit, id: 123
    end
  end

end
