require "spec_helper"

describe Register::CharactersController do
  describe "routing" do

    it "routes to #index" do
      get("/register_characters").should route_to("register_characters#index")
    end

    it "routes to #new" do
      get("/register_characters/new").should route_to("register_characters#new")
    end

    it "routes to #show" do
      get("/register_characters/1").should route_to("register_characters#show", :id => "1")
    end

    it "routes to #edit" do
      get("/register_characters/1/edit").should route_to("register_characters#edit", :id => "1")
    end

    it "routes to #create" do
      post("/register_characters").should route_to("register_characters#create")
    end

    it "routes to #update" do
      put("/register_characters/1").should route_to("register_characters#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/register_characters/1").should route_to("register_characters#destroy", :id => "1")
    end

  end
end
