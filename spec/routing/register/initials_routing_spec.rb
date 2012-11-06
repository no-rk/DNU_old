require "spec_helper"

describe Register::InitialsController do
  describe "routing" do

    it "routes to #index" do
      get("/register_initials").should route_to("register_initials#index")
    end

    it "routes to #new" do
      get("/register_initials/new").should route_to("register_initials#new")
    end

    it "routes to #show" do
      get("/register_initials/1").should route_to("register_initials#show", :id => "1")
    end

    it "routes to #edit" do
      get("/register_initials/1/edit").should route_to("register_initials#edit", :id => "1")
    end

    it "routes to #create" do
      post("/register_initials").should route_to("register_initials#create")
    end

    it "routes to #update" do
      put("/register_initials/1").should route_to("register_initials#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/register_initials/1").should route_to("register_initials#destroy", :id => "1")
    end

  end
end
