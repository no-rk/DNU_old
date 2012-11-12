require "spec_helper"

describe Register::ProductsController do
  describe "routing" do

    it "routes to #index" do
      get("/register_products").should route_to("register_products#index")
    end

    it "routes to #new" do
      get("/register_products/new").should route_to("register_products#new")
    end

    it "routes to #show" do
      get("/register_products/1").should route_to("register_products#show", :id => "1")
    end

    it "routes to #edit" do
      get("/register_products/1/edit").should route_to("register_products#edit", :id => "1")
    end

    it "routes to #create" do
      post("/register_products").should route_to("register_products#create")
    end

    it "routes to #update" do
      put("/register_products/1").should route_to("register_products#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/register_products/1").should route_to("register_products#destroy", :id => "1")
    end

  end
end
