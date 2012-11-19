require 'spec_helper'

describe "register/images/show" do
  before(:each) do
    @register_image = assign(:register_image, stub_model(Register::Image,
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
