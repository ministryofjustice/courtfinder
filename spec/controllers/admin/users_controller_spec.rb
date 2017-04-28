require 'spec_helper'

describe Admin::UsersController do
  let(:user) { create(:user, name: 'hello', admin: true, email: 'lol@biz.info') }

  before :each do
    sign_in user
  end

  describe "#index" do
    it "gets all users" do
      expect(User).to receive(:all).at_least(:once).and_return(User.where('id>0'))
      get :index
    end

    it "assigns @users" do
      get :index
      expect(assigns[:users]).to_not be_nil
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

  describe "#show" do
    let(:mock_user){ User.new }
    before{
      allow(User).to receive(:find).and_return( mock_user )
    }
    it "gets the user by id" do
      expect(User).to receive(:find).with('123').and_return(mock_user)
      get :show, id: 123
    end
    it "assigns @user" do
      get :show, id: 123
      expect(assigns[:user]).to eq(mock_user)
    end

    it "responds to html" do
      get :show, id: 123
      expect(response.content_type).to eq('text/html')
    end

    it "responds to json" do
      get :show, id: 123, format: :json
      expect(response.content_type).to eq('application/json')
    end

  end

  describe "#update" do
    let(:mock_user){ double('user', update_attributes: success) }
    before{
      allow(User).to receive(:find).and_return( mock_user )
    }
    context "with valid params" do
      let(:success){ true }
      let(:params){
        {
          id: 123,
          user: { name: 'user name' }
        }
      }

      it "updates the User" do
        expect(mock_user).to receive(:update_attributes).and_return(true)
        patch(:update, params)
      end


      it "redirects to the individual user path" do
        patch :update, params
        expect(response).to redirect_to(admin_user_path(mock_user))
      end
    end

    context "with invalid params" do
      let(:success){ false }
      let(:params){
        {
          id: 123,
          user: { name: '' }
        }
      }

      it "does not update a new User" do
        expect{ post(:update, params) }.to_not change(User, :count)
      end


      it "re-renders the edit template" do
        patch :update, params
        expect(response).to render_template(:edit)
      end
    end
  end



  describe "#destroy" do
    let(:mock_user){ double('user', destroy: success) }
    let(:success){ true }
    let(:params){ {id: 123} }

    before{
      allow(User).to receive(:find).and_return( mock_user )
    }
    it "tries to destroy the User" do
      expect(mock_user).to receive(:destroy).and_return(true)
      delete(:destroy, params)
    end

    context "when it successfully destroys the user" do
      let(:success){ true }

      it "redirects to the index" do
        delete(:destroy, params)
        expect(response).to redirect_to(admin_users_path)
      end
    end

    context "when it cannot destroy the user" do
      let(:success){ false }
      it 'flashes an error' do
        delete(:destroy, params)
        expect(flash[:error]).to_not be_empty
      end

      it "redirects to the index" do
        delete(:destroy, params)
        expect(response).to redirect_to(admin_users_path)
      end
    end

  end
end