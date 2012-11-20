require 'spec_helper'

describe "register/battles/index" do
  before(:each) do
    assign(:register_battles, [
      stub_model(Register::Battle,
        :user => nil
      ),
      stub_model(Register::Battle,
        :user => nil
      )
    ])
  end

  it "renders a list of register/battles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
