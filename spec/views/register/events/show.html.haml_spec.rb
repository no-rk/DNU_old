require 'spec_helper'

describe "register/events/show" do
  before(:each) do
    @register_event = assign(:register_event, stub_model(Register::Event,
      :user => nil,
      :day => nil,
      :event => nil
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
