require "spec_helper"

describe Register::MessagesController do
  describe "routing" do

    it "routes to #index" do
      get("/register/messages").should route_to("register/messages#index")
    end

    it "routes to #new" do
      get("/register/messages/new").should route_to("register/messages#new")
    end

    it "routes to #show" do
      get("/register/messages/1").should route_to("register/messages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/register/messages/1/edit").should route_to("register/messages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/register/messages").should route_to("register/messages#create")
    end

    it "routes to #update" do
      put("/register/messages/1").should route_to("register/messages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/register/messages/1").should route_to("register/messages#destroy", :id => "1")
    end

  end
end
