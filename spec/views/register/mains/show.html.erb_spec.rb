require 'spec_helper'

describe "register_mains/show" do
  before(:each) do
    @main = assign(:main, stub_model(Register::Main,
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
