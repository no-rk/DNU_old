require 'spec_helper'

describe "register/messages/index" do
  before(:each) do
    assign(:register_messages, [
      stub_model(Register::Message),
      stub_model(Register::Message)
    ])
  end

  it "renders a list of register/messages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
