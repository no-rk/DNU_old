require 'spec_helper'

describe TestsController do

  describe "GET 'battle'" do
    it "returns http success" do
      get 'battle'
      response.should be_success
    end
  end

  describe "GET 'skill'" do
    it "returns http success" do
      get 'skill'
      response.should be_success
    end
  end

  describe "GET 'sup'" do
    it "returns http success" do
      get 'sup'
      response.should be_success
    end
  end

  describe "GET 'ability'" do
    it "returns http success" do
      get 'ability'
      response.should be_success
    end
  end

end
