require "spec_helper"

describe Register::EventsController do
  describe "routing" do

    it "routes to #index" do
      get("/register/events").should route_to("register/events#index")
    end

    it "routes to #new" do
      get("/register/events/new").should route_to("register/events#new")
    end

    it "routes to #show" do
      get("/register/events/1").should route_to("register/events#show", :id => "1")
    end

    it "routes to #edit" do
      get("/register/events/1/edit").should route_to("register/events#edit", :id => "1")
    end

    it "routes to #create" do
      post("/register/events").should route_to("register/events#create")
    end

    it "routes to #update" do
      put("/register/events/1").should route_to("register/events#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/register/events/1").should route_to("register/events#destroy", :id => "1")
    end

  end
end
