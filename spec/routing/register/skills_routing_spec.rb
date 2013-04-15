require "spec_helper"

describe Register::SkillsController do
  describe "routing" do

    it "routes to #index" do
      get("/register/skills").should route_to("register/skills#index")
    end

    it "routes to #new" do
      get("/register/skills/new").should route_to("register/skills#new")
    end

    it "routes to #show" do
      get("/register/skills/1").should route_to("register/skills#show", :id => "1")
    end

    it "routes to #edit" do
      get("/register/skills/1/edit").should route_to("register/skills#edit", :id => "1")
    end

    it "routes to #create" do
      post("/register/skills").should route_to("register/skills#create")
    end

    it "routes to #update" do
      put("/register/skills/1").should route_to("register/skills#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/register/skills/1").should route_to("register/skills#destroy", :id => "1")
    end

  end
end
