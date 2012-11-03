require "spec_helper"

describe Register::MakesController do
  describe "routing" do

    it "routes to #index" do
      get("/register_makes").should route_to("register_makes#index")
    end

    it "routes to #new" do
      get("/register_makes/new").should route_to("register_makes#new")
    end

    it "routes to #show" do
      get("/register_makes/1").should route_to("register_makes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/register_makes/1/edit").should route_to("register_makes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/register_makes").should route_to("register_makes#create")
    end

    it "routes to #update" do
      put("/register_makes/1").should route_to("register_makes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/register_makes/1").should route_to("register_makes#destroy", :id => "1")
    end

  end
end
