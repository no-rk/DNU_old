require 'spec_helper'

describe "register/communities/index" do
  before(:each) do
    assign(:register_communities, [
      stub_model(Register::Community,
        :user => nil,
        :day => nil
      ),
      stub_model(Register::Community,
        :user => nil,
        :day => nil
      )
    ])
  end

  it "renders a list of register/communities" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
