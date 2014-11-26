require 'spec_helper'

describe Admin::AddressesController do
  render_views

  before :each do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  describe "#index" do
    it "assigns all addresses" do
      get :index
      expect(assigns[:addresses]).to eq(Address.all)
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
    let(:address){ address = Address.create!(address_line_1: 'Room 101', town: Town.create!) }
    let(:params){ {id: address.id, address: {}} }
      
    context "when it works" do
      before{ address.stub(update_attributes: true) }

      it "purges the cache" do
        controller.should_receive(:purge_all_pages)
        post :update, params
      end

      describe "a html request" do
        before{ params[:format] = :html }

        it "redirects to the show path" do
          post :update, params
          response.should redirect_to(admin_address_path(address))
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
      before{ Address.any_instance.stub(update_attributes: false) }

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
    context "with valid params" do
      let(:town){ Town.create }
      let(:params){ {address: {address_line_1: '22 Acacia Avenue', town_id: town.id}} }

      it "creates a new Address" do
        expect{ post :create, params }.to change(Address, :count).by(1)
      end

      it "purges the cache" do
        controller.should_receive(:purge_all_pages)
        post :create, params
      end

      describe "a html request" do
        before{ params[:format] = :html }

        it "redirects to show the new Address" do
          post :create, params
          expect(response).to redirect_to(admin_address_path(Address.last))
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

    context "with invalid params" do
      let(:params){ {address: {address_line_2: '22 Acacia Avenue'}}  }

      it "does not create an Address" do
        expect{ post :create, params }.to_not change(Address, :count)
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
    let(:town){ Town.create(name: 'Testington') }
    let(:address){ Address.create(address_line_1: '22 Acacia Avenue', town: town) }

    it "finds the right address" do 
      Address.should_receive(:find).with(address.id.to_s).and_return(address)
      get :edit, id: town.id
    end

    it "assigns the address" do
      get :edit, id: address.id
      expect(assigns[:address]).to eq(address)
    end
  end

  describe "#new" do
    it "assigns a new address to @address" do
      get :new
      expect(assigns[:address]).to be_a(Address)
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
    let(:town){ Town.create(name: 'Testington') }
    let(:address){ Address.create(address_line_1: '22 Acacia Avenue', town: town) }

    it "finds the right address" do 
      Address.should_receive(:find).with(address.id.to_s).and_return(address)
      get :show, id: address.id
    end

    it "assigns the address" do
      get :show, id: address.id
      expect(assigns[:address]).to eq(address)
    end

    describe "a html request" do
      it "responds with html" do
        get :show, id: address.id, format: :html
        expect(response.content_type).to eq('text/html')
      end

      it "responds with :ok" do
        get :show, id: address.id, format: :html
        expect( response.status ).to eq(200)
      end
    end
    
    describe "a json request" do
      it "responds with json" do
        get :show, id: address.id, format: :json
        expect(response.content_type).to eq('application/json')
      end

      it "responds with :ok" do
        get :show, id: address.id, format: :json
        expect( response.status ).to eq(200)
      end
    end
  end

  it "purges the cache when a address is destroyed" do
    at = Address.create!(address_line_1: 'Room 101', town: Town.create!)
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: at.id
      response.should redirect_to(admin_addresses_path)
    }.to change { Address.count }.by(-1)
  end
end
