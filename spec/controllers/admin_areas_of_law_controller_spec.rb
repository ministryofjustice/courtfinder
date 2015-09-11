require 'spec_helper'

describe Admin::AreasOfLawController do
  before :each do
    sign_in User.create!(name: 'hello', admin: true, email: 'lol@biz.info', password: 'irrelevant')
  end

  describe "#index" do
    it "assigns all areas" do
      get :index
      expect(assigns[:areas_of_law]).to eq(AreaOfLaw.all)
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

  describe "#show" do
    let(:area){ AreaOfLaw.create(name: 'Somewhere') }

    it "finds the right area" do
      AreaOfLaw.should_receive(:find).with(area.id.to_s).and_return(area)
      get :show, id: area.id
    end

    it "assigns the area" do
      get :show, id: area.id
      expect(assigns[:area_of_law]).to eq(area)
    end

    describe "a html request" do
      it "responds with html" do
        get :show, id: area.id, format: :html
        expect(response.content_type).to eq('text/html')
      end

      it "responds with :ok" do
        get :show, id: area.id, format: :html
        expect( response.status ).to eq(200)
      end
    end

    describe "a json request" do
      it "responds with json" do
        get :show, id: area.id, format: :json
        expect(response.content_type).to eq('application/json')
      end

      it "responds with :ok" do
        get :show, id: area.id, format: :json
        expect( response.status ).to eq(200)
      end
    end
  end
end
