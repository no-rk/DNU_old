require 'spec_helper'

describe "register_makes/index" do
  before(:each) do
    assign(:register_makes, [
      stub_model(Register::Make,
        :user => nil
      ),
      stub_model(Register::Make,
        :user => nil
      )
    ])
  end

  it "renders a list of register_makes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
