require 'spec_helper'

describe "Register::Competitions" do
  describe "GET /register_competitions" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get register_competitions_path
      response.status.should be(200)
    end
  end
end
