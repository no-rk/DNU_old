require 'spec_helper'

describe "register_trades/index" do
  before(:each) do
    assign(:register_trades, [
      stub_model(Register::Trade,
        :user => nil
      ),
      stub_model(Register::Trade,
        :user => nil
      )
    ])
  end

  it "renders a list of register_trades" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
