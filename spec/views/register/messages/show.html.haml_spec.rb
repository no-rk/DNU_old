require 'spec_helper'

describe "register/messages/show" do
  before(:each) do
    @register_message = assign(:register_message, stub_model(Register::Message))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
