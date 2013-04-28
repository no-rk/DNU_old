require 'spec_helper'

describe "register/messages/new" do
  before(:each) do
    assign(:register_message, stub_model(Register::Message).as_new_record)
  end

  it "renders new register_message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", register_messages_path, "post" do
    end
  end
end
