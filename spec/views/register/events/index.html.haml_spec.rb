require 'spec_helper'

describe "register/events/index" do
  before(:each) do
    assign(:register_events, [
      stub_model(Register::Event,
        :user => nil,
        :day => nil,
        :event => nil
      ),
      stub_model(Register::Event,
        :user => nil,
        :day => nil,
        :event => nil
      )
    ])
  end

  it "renders a list of register/events" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
