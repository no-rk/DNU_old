require "spec_helper"

describe Register::CommunitiesController do
  describe "routing" do

    it "routes to #index" do
      get("/register/communities").should route_to("register/communities#index")
    end

    it "routes to #new" do
      get("/register/communities/new").should route_to("register/communities#new")
    end

    it "routes to #show" do
      get("/register/communities/1").should route_to("register/communities#show", :id => "1")
    end

    it "routes to #edit" do
      get("/register/communities/1/edit").should route_to("register/communities#edit", :id => "1")
    end

    it "routes to #create" do
      post("/register/communities").should route_to("register/communities#create")
    end

    it "routes to #update" do
      put("/register/communities/1").should route_to("register/communities#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/register/communities/1").should route_to("register/communities#destroy", :id => "1")
    end

  end
end
