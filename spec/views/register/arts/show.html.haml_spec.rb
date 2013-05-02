require 'spec_helper'

describe "register/arts/show" do
  before(:each) do
    @register_art = assign(:register_art, stub_model(Register::Art,
      :user => nil,
      :day => nil,
      :art_effect => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(//)
  end
end
