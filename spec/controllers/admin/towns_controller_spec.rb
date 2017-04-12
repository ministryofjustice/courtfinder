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
end