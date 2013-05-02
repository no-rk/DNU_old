require "spec_helper"

describe Register::ArtsController do
  describe "routing" do

    it "routes to #index" do
      get("/register/arts").should route_to("register/arts#index")
    end

    it "routes to #new" do
      get("/register/arts/new").should route_to("register/arts#new")
    end

    it "routes to #show" do
      get("/register/arts/1").should route_to("register/arts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/register/arts/1/edit").should route_to("register/arts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/register/arts").should route_to("register/arts#create")
    end

    it "routes to #update" do
      put("/register/arts/1").should route_to("register/arts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/register/arts/1").should route_to("register/arts#destroy", :id => "1")
    end

  end
end
