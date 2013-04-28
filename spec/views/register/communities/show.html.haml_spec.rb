require 'spec_helper'

describe "register/communities/show" do
  before(:each) do
    @register_community = assign(:register_community, stub_model(Register::Community,
      :user => nil,
      :day => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
  end
end
