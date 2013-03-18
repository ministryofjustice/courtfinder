require "spec_helper"

describe OpeningTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/opening_types").should route_to("opening_types#index")
    end

    it "routes to #new" do
      get("/opening_types/new").should route_to("opening_types#new")
    end

    it "routes to #show" do
      get("/opening_types/1").should route_to("opening_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/opening_types/1/edit").should route_to("opening_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/opening_types").should route_to("opening_types#create")
    end

    it "routes to #update" do
      put("/opening_types/1").should route_to("opening_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/opening_types/1").should route_to("opening_types#destroy", :id => "1")
    end

  end
end
