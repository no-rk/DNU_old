require 'spec_helper'

describe "register/battles/show" do
  before(:each) do
    @register_battle = assign(:register_battle, stub_model(Register::Battle,
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
