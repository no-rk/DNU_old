require 'spec_helper'

describe "register/messages/edit" do
  before(:each) do
    @register_message = assign(:register_message, stub_model(Register::Message))
  end

  it "renders the edit register_message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", register_message_path(@register_message), "post" do
    end
  end
end
