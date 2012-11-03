require 'spec_helper'

describe "register_characters/index" do
  before(:each) do
    assign(:register_characters, [
      stub_model(Register::Character,
        :user => nil
      ),
      stub_model(Register::Character,
        :user => nil
      )
    ])
  end

  it "renders a list of register_characters" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
