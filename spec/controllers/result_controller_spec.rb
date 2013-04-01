require 'spec_helper'

describe ResultController do

  describe "GET 'eno'" do
    it "returns http success" do
      get 'eno'
      response.should be_success
    end
  end

end
