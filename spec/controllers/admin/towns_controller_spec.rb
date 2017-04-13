require 'spec_helper'

describe Admin::TownsController do
  let(:user) { User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant') }
  let(:town) { create(:town) }

  before :each do
    sign_in user
  end

  describe 'GET' do
    context 'index' do
      it "render template" do
        get :index

        expect(response).to render_template(:index)
        expect(response).to be_success
      end
    end

    context 'new' do
      it "render template" do
        get :new

        expect(response).to render_template(:new)
        expect(response).to be_success
      end
    end

    context 'show' do
      it "render template" do
        get :show, id: town.id

        expect(response).to render_template(:show)
        expect(response).to be_success
      end
    end

    context 'edit' do
      it "render template" do
        get :edit, id: town.id

        expect(response).to render_template(:edit)
        expect(response).to be_success
      end
    end
  end

  describe 'POST' do
    context 'create' do
      it "new town" do
        post :create, town: { name: 'Brno' }

        expect(response).to redirect_to admin_town_path(assigns(:town))
      end
    end

    context 'create json' do
      it "new town" do
        post :create, town: { name: 'Brno' }, format: :json

        expect(response.body).to eql(assigns(:town).to_json)
      end
    end
  end

  describe 'PUT' do
    context 'update' do
      it "change name of the town" do
        put :update, id: town.id, town: { name: 'Brno1' }

        expect(response).to redirect_to admin_town_path(town)
      end
    end

    context 'updatea json' do
      it "change name of the town" do
        put :update, id: town.id, town: { name: 'Brno1' }, format: :json
        expect(town.reload.name).to eql('Brno1')
      end
    end
  end

  describe 'DELETE' do
    context 'destroy' do
      it "change name of the town" do
        delete :destroy, id: town.id

        expect(response).to redirect_to admin_towns_url
      end
    end

    context 'updatea json' do
      it "change name of the town" do
        delete :destroy, id: town.id, format: :json

        expect(Town.count).to eql(0)
      end
    end
  end
end