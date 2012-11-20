require "spec_helper"

describe Register::CompetitionsController do
  describe "routing" do

    it "routes to #index" do
      get("/register/competitions").should route_to("register/competitions#index")
    end

    it "routes to #new" do
      get("/register/competitions/new").should route_to("register/competitions#new")
    end

    it "routes to #show" do
      get("/register/competitions/1").should route_to("register/competitions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/register/competitions/1/edit").should route_to("register/competitions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/register/competitions").should route_to("register/competitions#create")
    end

    it "routes to #update" do
      put("/register/competitions/1").should route_to("register/competitions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/register/competitions/1").should route_to("register/competitions#destroy", :id => "1")
    end

  end
end
