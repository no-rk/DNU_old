require "spec_helper"

describe Register::MainsController do
  describe "routing" do

    it "routes to #index" do
      get("/register_mains").should route_to("register_mains#index")
    end

    it "routes to #new" do
      get("/register_mains/new").should route_to("register_mains#new")
    end

    it "routes to #show" do
      get("/register_mains/1").should route_to("register_mains#show", :id => "1")
    end

    it "routes to #edit" do
      get("/register_mains/1/edit").should route_to("register_mains#edit", :id => "1")
    end

    it "routes to #create" do
      post("/register_mains").should route_to("register_mains#create")
    end

    it "routes to #update" do
      put("/register_mains/1").should route_to("register_mains#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/register_mains/1").should route_to("register_mains#destroy", :id => "1")
    end

  end
end
