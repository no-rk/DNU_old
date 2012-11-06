require 'spec_helper'

describe "register_initials/index" do
  before(:each) do
    assign(:register_initials, [
      stub_model(Register::Initial,
        :user => nil
      ),
      stub_model(Register::Initial,
        :user => nil
      )
    ])
  end

  it "renders a list of register_initials" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
