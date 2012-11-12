require 'spec_helper'

describe "register_mains/index" do
  before(:each) do
    assign(:register_mains, [
      stub_model(Register::Main,
        :user => nil
      ),
      stub_model(Register::Main,
        :user => nil
      )
    ])
  end

  it "renders a list of register_mains" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
