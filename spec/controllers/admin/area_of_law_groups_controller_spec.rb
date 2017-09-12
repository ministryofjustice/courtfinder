require 'spec_helper'

describe Admin::AreaOfLawGroupsController do

  before :each do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  describe "#index" do
    it "assigns all groups" do
      get :index
      expect(assigns[:groups]).to eq(AreaOfLawGroup.all)
    end

    describe "a html request" do
      it "responds with html" do
        get :index
        expect(response.content_type).to eq('text/html')
      end

      it "responds with :ok" do
        get :index
        expect(response.status).to eq(200)
      end
    end

    describe "a json request" do
      it "responds with json" do
        get :index, format: :json
        expect(response.content_type).to eq('application/json')
      end

      it "responds with :ok" do
        get :index, format: :json
        expect(response.status).to eq(200)
      end
    end
  end

  describe "#update" do
    let(:group) { AreaOfLawGroup.create!(name: 'the north') }
    let(:params) { { id: group.id, area_of_law_group: {} } }

    context "when it works" do
      before { group.stub(update_attributes: true) }

      describe "a html request" do
        before { params[:format] = :html }

        it "redirects to the index path" do
          put :update, params
          response.should redirect_to(admin_area_of_law_groups_path)
        end

        it "flashes a notice" do
          put :update, params
          expect(flash[:notice]).to_not be_empty
        end
      end

      describe "a json request" do
        before { params[:format] = :json }

        it "reponds with json" do
          put :update, params
          expect(response.content_type).to eq('application/json')
        end

        it "responds with no content" do
          put :update, params
          expect(response.status).to eq(204)
        end
      end
    end

    context "when it doesn't work" do
      before { AreaOfLawGroup.any_instance.stub(update_attributes: false) }

      describe "a html request" do
        before { params[:format] = :html }

        it "rerenders the edit template" do
          put :update, params
          response.should render_template(:edit)
        end

        it "flashes an error" do
          put :update, params
          expect(flash[:error]).to_not be_empty
        end
      end
    end
  end

  describe "#create" do
    context "that works" do
      let(:params) { { area_of_law_group: { name: '22 Acacia Avenue' } } }

      it "creates a new Area" do
        expect { post :create, params }.to change(AreaOfLawGroup, :count).by(1)
      end

      describe "a html request" do
        before { params[:format] = :html }

        it "redirects to the index" do
          post :create, params
          expect(response).to redirect_to(admin_area_of_law_groups_path)
        end

        it "flashes a notice" do
          post :create, params
          expect(flash[:notice]).to_not be_empty
        end
      end

      describe "a json request" do
        before { params[:format] = :json }

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
      let(:params) { { area_of_law_group: { name: 'something' } } }
      before { AreaOfLawGroup.any_instance.stub(save: false) }

      it "does not create an Area" do
        expect { post :create, params }.to_not change(AreaOfLawGroup, :count)
      end

      describe "a html request" do
        before { params[:format] = :html }

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
        before { params[:format] = :json }

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
    let(:group) { AreaOfLawGroup.create(name: '22 Acacia Avenue') }

    it "finds the right area" do
      AreaOfLawGroup.should_receive(:find).with(group.id.to_s).and_return(group)
      get :edit, id: group.id
    end

    it "assigns the area" do
      get :edit, id: group.id
      expect(assigns[:group]).to eq(group)
    end
  end

  describe "#new" do
    it "assigns a new area_of_law_group to @area" do
      get :new
      expect(assigns[:group]).to be_a(AreaOfLawGroup)
    end

    describe "a html request" do
      it "responds with html" do
        get :index
        expect(response.content_type).to eq('text/html')
      end

      it "responds with :ok" do
        get :new, format: :html
        expect(response.status).to eq(200)
      end
    end
  end

  it "delete area_of_law_group on destroyed" do
    at = AreaOfLawGroup.create!(name: 'somewhere')
    expect {
      post :destroy, id: at.id
      response.should redirect_to(admin_area_of_law_groups_path)
    }.to change { AreaOfLawGroup.count }.by(-1)
  end
end
