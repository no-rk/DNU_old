require "spec_helper"

describe Register::BattlesController do
  describe "routing" do

    it "routes to #index" do
      get("/register/battles").should route_to("register/battles#index")
    end

    it "routes to #new" do
      get("/register/battles/new").should route_to("register/battles#new")
    end

    it "routes to #show" do
      get("/register/battles/1").should route_to("register/battles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/register/battles/1/edit").should route_to("register/battles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/register/battles").should route_to("register/battles#create")
    end

    it "routes to #update" do
      put("/register/battles/1").should route_to("register/battles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/register/battles/1").should route_to("register/battles#destroy", :id => "1")
    end

  end
end
