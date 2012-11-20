require 'spec_helper'

describe "register/duels/index" do
  before(:each) do
    assign(:register_duels, [
      stub_model(Register::Duel,
        :user => nil
      ),
      stub_model(Register::Duel,
        :user => nil
      )
    ])
  end

  it "renders a list of register/duels" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
