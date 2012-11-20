require 'spec_helper'

describe "register/competitions/index" do
  before(:each) do
    assign(:register_competitions, [
      stub_model(Register::Competition,
        :user => nil
      ),
      stub_model(Register::Competition,
        :user => nil
      )
    ])
  end

  it "renders a list of register/competitions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
