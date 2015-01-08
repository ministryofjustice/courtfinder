require 'spec_helper'

describe Admin::AddressTypesController do
  #render_views

  before :each do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  describe "#update" do
    let(:address_type){ AddressType.new(id: 123) }
    before{ 
      AddressType.stub(:find).and_return(address_type) 
      address_type.stub(id: 123)
    }

    let(:params){ { id: 123, address_type: {name: 'new address type'} } }

    context "that works" do
      before{ 
        AddressType.any_instance.stub(update_attributes: true)
      }

      it "purges the cache" do
        controller.should_receive(:purge_all_pages)
        patch :update, params
      end

      it "redirects to the edit path" do
        patch :update, params
        response.should redirect_to(edit_admin_address_type_path(address_type))
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
        AddressType.any_instance.stub(update_attributes: false)
      }

      it "does not purge the cache" do
        controller.should_not_receive(:purge_all_pages)
        patch :update, params
      end

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
    let(:params){ { address_type: {name: 'new address type'} } }

    context "that saves ok" do
      it "creates an address type" do
        expect{ 
          post :create, params
        }.to change { AddressType.count }.by(1)
      end

      it "purges the cache" do
        controller.should_receive(:purge_all_pages)
        post :create, params
      end

      it "redirects to the edit path" do
        post :create, params
        response.should redirect_to(edit_admin_address_type_path(assigns(:address_type)))
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
      before{ AddressType.any_instance.stub(save: false) }
      
      it "does not create an address type" do
        expect{ 
          post :create, params
        }.to_not change { AddressType.count }
      end

      it "does not purge the cache" do
        controller.should_not_receive(:purge_all_pages)
        post :create, params
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


  it "purges the cache when a address type is destroyed" do
    at = AddressType.create!
    expect {
      controller.should_receive(:purge_all_pages)
      post :destroy, id: at.id
      response.should redirect_to(admin_address_types_path)
    }.to change { AddressType.count }.by(-1)
  end

  describe "#index" do
    it "assigns all address_types to @address_types" do
      get :index
      expect(assigns[:address_types]).to eq(AddressType.all)
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
    let(:mock_address_type){ AddressType.new(id: 123, name: 'mock address type') }
    before{ 
      AddressType.stub(:find).and_return(mock_address_type)
    }

    it "gets the right address_type" do
      AddressType.should_receive(:find).with('123').and_return(mock_address_type)
      get :show, id: 123
    end

    it "assigns the address_type" do
      get :show, id: 123
      expect(assigns[:address_type]).to eq(mock_address_type)
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

    it "assigns a new address_type" do
      get :new
      expect(assigns[:address_type]).to be_a(AddressType)
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
    let(:mock_address_type){ AddressType.new(id: 123, name: 'mock address type') }
    before{ 
      AddressType.stub(:find).and_return(mock_address_type)
    }

    it "gets the right address_type" do
      AddressType.should_receive(:find).with('123').and_return(mock_address_type)
      get :edit, id: 123
    end
  end


end
