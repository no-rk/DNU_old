require 'spec_helper'

describe EditorsController do

  describe "GET 'map'" do
    it "returns http success" do
      get 'map'
      response.should be_success
    end
  end

end
