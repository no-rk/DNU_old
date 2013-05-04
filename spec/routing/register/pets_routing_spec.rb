require "spec_helper"

describe Register::PetsController do
  describe "routing" do

    it "routes to #index" do
      get("/register/pets").should route_to("register/pets#index")
    end

    it "routes to #new" do
      get("/register/pets/new").should route_to("register/pets#new")
    end

    it "routes to #show" do
      get("/register/pets/1").should route_to("register/pets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/register/pets/1/edit").should route_to("register/pets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/register/pets").should route_to("register/pets#create")
    end

    it "routes to #update" do
      put("/register/pets/1").should route_to("register/pets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/register/pets/1").should route_to("register/pets#destroy", :id => "1")
    end

  end
end
