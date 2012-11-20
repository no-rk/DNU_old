require "spec_helper"

describe Register::DuelsController do
  describe "routing" do

    it "routes to #index" do
      get("/register/duels").should route_to("register/duels#index")
    end

    it "routes to #new" do
      get("/register/duels/new").should route_to("register/duels#new")
    end

    it "routes to #show" do
      get("/register/duels/1").should route_to("register/duels#show", :id => "1")
    end

    it "routes to #edit" do
      get("/register/duels/1/edit").should route_to("register/duels#edit", :id => "1")
    end

    it "routes to #create" do
      post("/register/duels").should route_to("register/duels#create")
    end

    it "routes to #update" do
      put("/register/duels/1").should route_to("register/duels#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/register/duels/1").should route_to("register/duels#destroy", :id => "1")
    end

  end
end
