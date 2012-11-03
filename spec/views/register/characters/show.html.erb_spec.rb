require 'spec_helper'

describe "register_characters/show" do
  before(:each) do
    @character = assign(:character, stub_model(Register::Character,
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
