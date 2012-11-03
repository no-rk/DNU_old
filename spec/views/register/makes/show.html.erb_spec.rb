require 'spec_helper'

describe "register_makes/show" do
  before(:each) do
    @make = assign(:make, stub_model(Register::Make,
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
