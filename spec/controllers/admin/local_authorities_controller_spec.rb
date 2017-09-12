require 'spec_helper'

describe Admin::LocalAuthoritiesController do

  before :each do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  describe "#index" do
    it "gets local authorities by name" do
      LocalAuthority.should_receive(:by_name).and_return([])
      get :index
    end
    it "assigns @local_authorities" do
      get :index
      expect(assigns[:local_authorities]).to_not be_nil
    end

    it "responds to html" do
      get :index
      expect(response.content_type).to eq('text/html')
    end

    it "responds to json" do
      get :index, format: :json
      expect(response.content_type).to eq('application/json')
    end
  end

  describe "#new" do
    it "assigns @local_authority" do
      get :new, id: 123
      expect(assigns[:local_authority]).to be_a(LocalAuthority)
    end

    it "responds to html" do
      get :new, id: 123
      expect(response.content_type).to eq('text/html')
    end

    it "responds to json" do
      get :new, id: 123, format: :json
      expect(response.content_type).to eq('application/json')
    end
  end

  describe "#create" do
    context "with valid params" do
      let(:params) {
        {
          local_authority: { name: 'Authority name' }
        }
      }

      it "creates a new LocalAuthority" do
        expect { post(:create, params) }.to change(LocalAuthority, :count).by(1)
      end

      it "redirects to the index" do
        post :create, params
        expect(response).to redirect_to(admin_local_authorities_path)
      end
    end

    context "with invalid params" do
      let(:params) {
        {
          local_authority: { name: '' }
        }
      }

      it "does not create a new LocalAuthority" do
        expect { post(:create, params) }.to_not change(LocalAuthority, :count)
      end

      it "re-renders the new template" do
        post :create, params
        expect(response).to render_template(:new)
      end
    end
  end

  describe "#update" do
    let(:mock_authority) { double('local authority', update_attributes: success) }
    before {
      allow(LocalAuthority).to receive(:find).and_return(mock_authority)
    }
    context "with valid params" do
      let(:success) { true }
      let(:params) {
        {
          id: 123,
          local_authority: { name: 'Authority name' }
        }
      }

      it "updates the LocalAuthority" do
        mock_authority.should_receive(:update_attributes).and_return(true)
        patch(:update, params)
      end

      it "redirects to the index" do
        patch :update, params
        expect(response).to redirect_to(admin_local_authorities_path)
      end
    end

    context "with invalid params" do
      let(:success) { false }
      let(:params) {
        {
          id: 123,
          local_authority: { name: '' }
        }
      }

      it "does not update a new LocalAuthority" do
        expect { post(:update, params) }.to_not change(LocalAuthority, :count)
      end

      it "re-renders the edit template" do
        patch :update, params
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#edit" do
    let(:mock_authority) { LocalAuthority.new }
    before {
      LocalAuthority.stub(:find).and_return(mock_authority)
    }
    it "gets the local authority by id" do
      LocalAuthority.should_receive(:find).with('123').and_return(mock_authority)
      get :edit, id: 123
    end
    it "assigns @local_authority" do
      get :edit, id: 123
      expect(assigns[:local_authority]).to eq(mock_authority)
    end

    it "responds to html" do
      get :edit, id: 123
      expect(response.content_type).to eq('text/html')
    end

    it "responds to json" do
      get :edit, id: 123, format: :json
      expect(response.content_type).to eq('application/json')
    end
  end

  describe "#destroy" do
    let(:mock_authority) { double('local authority', destroy: success) }
    let(:success) { true }
    let(:params) { { id: 123 } }

    before {
      LocalAuthority.stub(:find).and_return(mock_authority)
    }
    it "tries to destroy the LocalAuthority" do
      mock_authority.should_receive(:destroy).and_return(true)
      delete(:destroy, params)
    end

    context "when it successfully destroys the local authority" do
      let(:success) { true }

      it 'flashes a notice' do
        delete(:destroy, params)
        expect(flash[:notice]).to_not be_empty
      end

      it "redirects to the index" do
        delete(:destroy, params)
        expect(response).to redirect_to(admin_local_authorities_path)
      end
    end

    context "when it cannot destroy the local authority" do
      let(:success) { false }
      it 'flashes an error' do
        delete(:destroy, params)
        expect(flash[:error]).to_not be_empty
      end

      it "redirects to the index" do
        delete(:destroy, params)
        expect(response).to redirect_to(admin_local_authorities_path)
      end
    end

  end
end
