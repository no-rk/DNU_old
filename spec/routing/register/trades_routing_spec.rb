require "spec_helper"

describe Register::TradesController do
  describe "routing" do

    it "routes to #index" do
      get("/register_trades").should route_to("register_trades#index")
    end

    it "routes to #new" do
      get("/register_trades/new").should route_to("register_trades#new")
    end

    it "routes to #show" do
      get("/register_trades/1").should route_to("register_trades#show", :id => "1")
    end

    it "routes to #edit" do
      get("/register_trades/1/edit").should route_to("register_trades#edit", :id => "1")
    end

    it "routes to #create" do
      post("/register_trades").should route_to("register_trades#create")
    end

    it "routes to #update" do
      put("/register_trades/1").should route_to("register_trades#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/register_trades/1").should route_to("register_trades#destroy", :id => "1")
    end

  end
end
