require "spec_helper"

describe Register::ImagesController do
  describe "routing" do

    it "routes to #index" do
      get("/register/images").should route_to("register/images#index")
    end

    it "routes to #new" do
      get("/register/images/new").should route_to("register/images#new")
    end

    it "routes to #show" do
      get("/register/images/1").should route_to("register/images#show", :id => "1")
    end

    it "routes to #edit" do
      get("/register/images/1/edit").should route_to("register/images#edit", :id => "1")
    end

    it "routes to #create" do
      post("/register/images").should route_to("register/images#create")
    end

    it "routes to #update" do
      put("/register/images/1").should route_to("register/images#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/register/images/1").should route_to("register/images#destroy", :id => "1")
    end

  end
end
