require "spec_helper"

describe Register::AbilitiesController do
  describe "routing" do

    it "routes to #index" do
      get("/register/abilities").should route_to("register/abilities#index")
    end

    it "routes to #new" do
      get("/register/abilities/new").should route_to("register/abilities#new")
    end

    it "routes to #show" do
      get("/register/abilities/1").should route_to("register/abilities#show", :id => "1")
    end

    it "routes to #edit" do
      get("/register/abilities/1/edit").should route_to("register/abilities#edit", :id => "1")
    end

    it "routes to #create" do
      post("/register/abilities").should route_to("register/abilities#create")
    end

    it "routes to #update" do
      put("/register/abilities/1").should route_to("register/abilities#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/register/abilities/1").should route_to("register/abilities#destroy", :id => "1")
    end

  end
end
