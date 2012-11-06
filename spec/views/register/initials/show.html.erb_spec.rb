require 'spec_helper'

describe "register_initials/show" do
  before(:each) do
    @initial = assign(:initial, stub_model(Register::Initial,
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
